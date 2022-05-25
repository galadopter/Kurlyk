//
//  Continuation+Optional.swift
//  Domain
//
//  Created by Yan Schneider on 19/05/2022.
//

import Foundation

public extension AsyncThrowingStream.Continuation {
    
    /// Resume the task depending on the result value.
    ///
    /// If it contains an element, continuation will yield this element into the sequence.
    /// If it contains `nil`, continuation will do nothing,
    /// If it contains failure, continuation will finish with error.
    func yield(optionally result: Result<Element?, Failure>) {
        switch result {
        case .success(.some(let element)):
            yield(element)
        case .success(.none):
            break
        case .failure(let error):
            finish(throwing: error)
        }
    }
}
