//
//  ValidateEntityUseCaseTests.swift
//  DomainTests
//
//  Created by Yan Schneider on 16.11.21.
//

import XCTest
import Domain
import Nimble

class ValidateEntityUseCaseTests: XCTestCase {
    
    func testShouldSucceed_whenValidationSucceeded() throws {
        let sut = self.makeSUT()
        
        try sut.execute(input: Mocks.createUser())
    }
    
    func testShouldFail_whenValidationFails() throws {
        let sut = self.makeSUT()
        
        expect(
            try sut.execute(input: .init(email: "", password: "", name: "", biography: ""))
        ).to(throwError(errorType: ValidationError.self))
    }
}

// MARK: - Private
private extension ValidateEntityUseCaseTests {
    
    func makeSUT() -> ValidateEntityUseCase<User.Create> {
        .init { user in
            IsEmailRule(email: user.email)
            HasMinimalLengthRule(value: user.password, length: 8)
        }
    }
}
