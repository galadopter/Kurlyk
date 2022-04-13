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
    
    /// Maps `Effect` to `Domain` type `None`.
    ///
    /// It's used because in Swift it is impossible to add `Equatable` conformance to `Void`.
    public func mapToNone() -> Effect<None, Failure> {
        map { None() }.eraseToEffect()
    }
}
