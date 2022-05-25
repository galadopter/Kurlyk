//
//  WebSocketEvent.swift
//  NetworkKit
//
//  Created by Yan Schneider on 25/05/2022.
//

import Foundation

public enum WebSocketEvent {
    case connected(String)
    case disconnected(String, UInt16)
    case text(String)
    case binary(Data)
    case pong(Data?)
    case ping(Data?)
    case error(Error?)
    case viabilityChanged(Bool)
    case reconnectSuggested(Bool)
    case cancelled
}
