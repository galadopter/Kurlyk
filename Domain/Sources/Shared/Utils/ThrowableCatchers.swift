//
//  ThrowableCatchers.swift
//  Domain
//
//  Created by Yan Schneider on 22.11.21.
//

import Foundation

public func shouldSucceed(_ block: () throws -> Void) -> Bool {
    do {
        try block()
        return true
    } catch {
        return false
    }
}
