//
//  File.swift
//  
//
//  Created by Yan Schneider on 14/08/2022.
//

import Foundation

extension Result {
    
    public var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    public var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
