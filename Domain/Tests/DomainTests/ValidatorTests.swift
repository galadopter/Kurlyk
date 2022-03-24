//
//  ValidatorTests.swift
//  DomainTests
//
//  Created by Yan Schneider on 15.11.21.
//

import XCTest
import Nimble
import Domain

class ValidatorTests: XCTestCase {
    
    func testShouldSucceed_whenCorrectEmailPassed() throws {
        let email = "test@example.com"

        try Validator.validate {
            IsEmailRule(email: email)
        }
    }
    
    func testShouldFaild_whenIncorrectEmailPassed() {
        shouldFail(rule: IsEmailRule(email: "testexample.com"))
        shouldFail(rule: IsEmailRule(email: "test@com"))
        shouldFail(rule: IsEmailRule(email: "test@example"))
        shouldFail(rule: IsEmailRule(email: "@example.com"))
    }
    
    func testShouldSucceed_whenLongEnoughStringPassed() throws {
        try Validator.validate {
            HasMinimalLengthRule(value: "abcd1234", length: 8)
            HasMinimalLengthRule(value: "abcd12345", length: 8)
        }
    }
    
    func testShouldFaild_whenSmallStringPassed() {
        shouldFail(rule: HasMinimalLengthRule(value: "abcd123", length: 8))
    }
}

// MARK: - Private
private extension ValidatorTests {

    func shouldFail(rule: ValidationRule) {
        expect(
            try Validator.validate {
                rule
            }
        ).to(throwError(errorType: ValidationError.self))
    }
}
