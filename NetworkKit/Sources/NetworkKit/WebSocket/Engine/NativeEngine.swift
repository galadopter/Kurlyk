//
//  NativeEngine.swift
//  Starscream
//
//  Created by Yan Schneider on 25/05/22.
//

import Foundation

public class NativeEngine: NSObject, Engine, URLSessionDataDelegate, URLSessionWebSocketDelegate {
    private var task: URLSessionWebSocketTask?
    weak var delegate: EngineDelegate?

    public func register(delegate: EngineDelegate) {
        self.delegate = delegate
    }

    public func start(endpoint: WebSocketEndpoint) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: endpoint.url)
        request.allHTTPHeaderFields = endpoint.headers
        task = session.webSocketTask(with: request)
        performRead()
        task?.resume()
    }

    public func stop(closeCode: UInt16) {
        let closeCode = URLSessionWebSocketTask.CloseCode(rawValue: Int(closeCode)) ?? .normalClosure
        task?.cancel(with: closeCode, reason: nil)
    }

    public func forceStop() {
        stop(closeCode: UInt16(URLSessionWebSocketTask.CloseCode.abnormalClosure.rawValue))
    }

    public func write(string: String) async throws {
        try await asyncWrite(message: .string(string))
    }

    public func write(data: Data) async throws {
        try await asyncWrite(message: .data(data))
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        broadcast(event: .connected(`protocol` ?? ""))
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        let reasonString = reason.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        broadcast(event: .disconnected(reasonString, UInt16(closeCode.rawValue)))
    }
}

// MARK: - Private
private extension NativeEngine {
    
    private func performRead() {
        task?.receive { [weak self] (result) in
            switch result {
            case .success(let message):
                switch message {
                case .string(let string):
                    self?.broadcast(event: .text(string))
                case .data(let data):
                    self?.broadcast(event: .binary(data))
                @unknown default:
                    break
                }
                break
            case .failure(let error):
                self?.broadcast(event: .error(error))
            }
            self?.performRead()
        }
    }
    
    private func asyncWrite(message: URLSessionWebSocketTask.Message) async throws {
        try await withUnsafeThrowingContinuation { [weak self] (continuation: UnsafeContinuation<Void, Error>) in
            self?.task?.send(message, completionHandler: { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            })
        }
    }

    private func broadcast(event: WebSocketEvent) {
        delegate?.didReceive(event: event)
    }
}
