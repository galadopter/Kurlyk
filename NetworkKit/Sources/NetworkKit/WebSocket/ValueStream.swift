//
//  ValueStream.swift
//  Infrastructure
//
//  Created by Yan Schneider on 19/05/2022.
//

import Foundation

/// Base class for all streams of data. It meant to be used as superclass to all data streams.
///
/// In order to create a stream of data, you need to specify `ChannelType` and create a subclass of `ValueStream`.
///
/// Here's an example of how you can divide your API into streams:
///   - `profile --> ProfileAPI + ProfileStream`
///   - `product --> ProfileAPI + ProfileStream`
open class ValueStream<Channel: ChannelType> {
    
    public let connection: WebSocketConnection<Channel>
    
    /// Initializer for ValueStream.
    ///
    /// - Parameter connection: WebSocket connection for specified stream.
    public init(connection: WebSocketConnection<Channel>) {
        self.connection = connection
    }
}
