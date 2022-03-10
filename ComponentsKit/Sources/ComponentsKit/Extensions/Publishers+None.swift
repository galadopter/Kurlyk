//
//  Publishers+None.swift
//  Kurlyk
//
//  Created by Yan Schneider on 26.11.21.
//

import Combine
import ComposableArchitecture
import Domain

extension Publisher where Output == Void {
    
    public func mapToNone() -> Effect<None, Failure> {
        map { None() }.eraseToEffect()
    }
}
