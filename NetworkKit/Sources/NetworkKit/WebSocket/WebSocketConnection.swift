//
//  WebSocketConnection.swift
//  Infrastructure
//
//  Created by Yan Schneider on 19/05/2022.
//

import Foundation

/// Handles connection via WebSocket protocol.
///
/// This is an actor object, so it can be safely used in different threads as it uses it's own private executor
/// to change it's data.
///
/// Uses URLSession WebSocket under-the-hood by default.
public actor WebSocketConnection<Channel: ChannelType> {
    
    private let endpoint: WebSocketEndpoint
    private let engine: Engine
    
    struct SubscriptionID: Hashable {
        let uuid: UUID
        let channel: Channel
        
        init(channel: Channel) {
            uuid = .init()
            self.channel = channel
        }
    }
    
    typealias Subscription = (WebSocketEvent) -> Void
    private(set) var subscriptions = [SubscriptionID: Subscription]()
    
    public enum WebSocketError: Error {
        case failedConvertingData
        case disconnected
        case cancelled
    }
    
    /// Initializer for `WebSocketConnection`.
    ///
    /// - Parameter endpoint: WebSocket endpoint, defines connection url and request headers.
    /// - Parameter engine: WebSocket engine, which is used by underlying WebSocket connection. Default: `NativeEngine`.
    /// - Parameter connectOnInitialization: Flag which controls whether this connection is going to connect to endpoint in the end of initialization. Default: `true`.
    public init(
        endpoint: WebSocketEndpoint,
        engine: Engine = NativeEngine(),
        connectOnInitialization: Bool = true
    ) {
        self.endpoint = endpoint
        self.engine = engine
        engine.register(delegate: self)
        
        if connectOnInitialization {
            Task {
                await connect()
            }
        }
    }
    
    deinit {
        engine.stop(closeCode: CloseCode.normal.rawValue)
    }
    
    /// Connects to WebSocket.
    ///
    /// Use this method only if you initialized connection with `connectOnInitialization: false`.
    ///
    /// - Note: This is actor isolated method, so you'll need to use `await` if you want to call it.
    public func connect() {
        engine.register(delegate: self)
        engine.start(endpoint: endpoint)
    }
    
    /// Subscribes to a given channel.
    ///
    /// This method returns `AsyncThrowingStream<Message, Error>` which can be used as a plain asynchronous sequence to iterate every element over time.
    ///
    ///     let connection = WebSocketConnection<ProductAPI>(endpoint: endpoint)
    ///     let priceStream = connection.subscribe(.currentPrice)
    ///
    ///     for try await price in priceStream {
    ///         print(price)
    ///     }
    ///
    /// - Note: This method is nonisolated to actor, which means that every change to
    ///  actor's underlying data happens in separate Task under-the-hood.
    ///
    /// - Parameter channel: Particular channel, which is used for subscription.
    /// - Parameter decoder: Instance of `JSONDecoder` which is used to parse text data from WebSocket.
    ///
    /// - Returns: `AsyncThrowingStream` with expected message or error.
    public nonisolated func subscribe<Message: Codable>(
        _ channel: Channel,
        decoder: JSONDecoder = .init()
    ) -> AsyncThrowingStream<Message, Error> {
        return .init { [weak self] continuation in
            let subscription: Subscription = { event in
                self?.onEvent(event, decoder: decoder, yieldInto: continuation)
            }
            
            let subscriptionID = SubscriptionID(channel: channel)
            
            continuation.onTermination = { [weak self] _ in
                self?.onTermination(subscriptionID: subscriptionID)
            }
            
            self?.register(subscription: subscription, id: subscriptionID)
        }
    }
    
    /// Sends message to WebSocket.
    ///
    /// - Note: This is actor isolated method, so you'll need to use `await` if you want to call it.
    ///
    /// - Parameter message: Message to be sent to WebSocket connection. Conforms to `Codable`.
    /// - Parameter encoder: Instance of `JSONEncoder` which is used to encode the message.
    public func send<Message: Codable>(message: Message, encoder: JSONEncoder = .init()) async throws {
        guard let data = try? encoder.encode(message) else { return }
        try await engine.write(data: data)
    }
}

// MARK: - WebSocketDelegate
extension WebSocketConnection: EngineDelegate {
    
    nonisolated public func didReceive(event: WebSocketEvent) {
        Task {
            await subscriptions.forEach { _, subscription in
                subscription(event)
            }
        }
    }
}

// MARK: - Event handling
private extension WebSocketConnection {
    
    nonisolated func onEvent<Message: Codable>(
        _ event: WebSocketEvent,
        decoder: JSONDecoder,
        yieldInto continuation: AsyncThrowingStream<Message, Error>.Continuation
    ) {
        switch event {
        case .text(let text):
            let result = Result<WebSocketMessage<Message>?, Error> {
                try parse(text: text, decoder: decoder)
            }
            
            // We need to yield it optionally, cause we don't want to throw if we received a message of another type.
            continuation.yield(optionally: result.map { $0?.body })
        case .disconnected:
            continuation.finish(throwing: WebSocketError.disconnected)
        case .cancelled:
            continuation.finish(throwing: WebSocketError.cancelled)
        case .error(let error):
            continuation.finish(throwing: error)
        case .reconnectSuggested:
            Task {
                await connect()
            }
        default:
            break
        }
    }
    
    nonisolated func parse<Message: Codable>(text: String, decoder: JSONDecoder) throws -> WebSocketMessage<Message>? {
        guard let data = text.data(using: .utf8) else {
            throw WebSocketError.failedConvertingData
        }
        
        return try? decoder.decode(WebSocketMessage<Message>.self, from: data)
    }
}

// MARK: - Nonisolated helpers
private extension WebSocketConnection {
    
    nonisolated func onTermination(subscriptionID: SubscriptionID) {
        Task { [weak self] in
            await self?.remove(subscription: subscriptionID)
        }
    }
    
    nonisolated func register(subscription: @escaping Subscription, id: SubscriptionID) {
        Task { [weak self] in
            await self?.add(subscription: subscription, id: id)
        }
    }
}

// MARK: - Subscriptions
private extension WebSocketConnection {
    
    func add(subscription: @escaping Subscription, id: SubscriptionID) async {
        subscriptions[id] = subscription
        
        if subscriptions.filter({ $0.key.channel == id.channel }).count == 1 {
            try? await send(message: SubscribeToMessage(products: [id.channel.name]))
        }
    }
    
    func remove(subscription id: SubscriptionID) async {
        subscriptions.removeValue(forKey: id)
        
        if !subscriptions.contains(where: { $0.key.channel == id.channel }) {
            try? await send(message: UnsubscribeFromMessage(products: [id.channel.name]))
        }
    }
}
