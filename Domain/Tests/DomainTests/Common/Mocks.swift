//
//  Mocks.swift
//  DomainTests
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation
import Domain

struct Mocks {
    
    static func createUser(
        email: String = "test@example.com",
        password: String = "abcd1234",
        name: String = "Test User",
        biography: String = "Some interesting information"
    ) -> User.Create {
        .init(
            email: email,
            password: password,
            name: name,
            biography: biography
        )
    }
    
    static func error(
        error: TestError = .generic
    ) -> Error {
        error
    }
}
