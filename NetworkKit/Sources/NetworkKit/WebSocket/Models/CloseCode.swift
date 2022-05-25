//
//  CloseCode.swift
//  NetworkKit
//
//  Created by Yan Schneider on 25/05/2022.
//

import Foundation

// Standard WebSocket close codes
public enum CloseCode: UInt16 {
    case normal = 1000
    case goingAway = 1001
    case protocolError = 1002
    case protocolUnhandledType = 1003
    // 1004 reserved.
    case noStatusReceived = 1005
    //1006 reserved.
    case encoding = 1007
    case policyViolated = 1008
    case messageTooBig = 1009
}
