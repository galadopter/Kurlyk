//
//  FrameOpCode.swift
//  NetworkKit
//
//  Created by Yan Schneider on 25/05/2022.
//

import Foundation

public enum FrameOpCode: UInt8 {
    case continueFrame = 0x0
    case textFrame = 0x1
    case binaryFrame = 0x2
    // 3-7 are reserved.
    case connectionClose = 0x8
    case ping = 0x9
    case pong = 0xA
    // B-F reserved.
    case unknown = 100
}
