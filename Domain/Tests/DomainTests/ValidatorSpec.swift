//
//  ValidatorSpec.swift
//  DomainTests
//
//  Created by Yan Schneider on 15.11.21.
//

import XCTest
import Domain
import Quick
import Nimble

class ValidatorSpec: QuickSpec {
    
    override func spec() {
        describe("validating data") {
            context("when correct email passed") {
                it("succeeds") {
                    let email = "test@example.com"
                    
                    try Validator.validate {
                        IsEmailRule(email: email)
                    }
                }
            }
            
            context("when incorrect emails passed") {
                it("fails") {
                    self.shouldFail(rule: IsEmailRule(email: "testexample.com"))
                    self.shouldFail(rule: IsEmailRule(email: "test@com"))
                    self.shouldFail(rule: IsEmailRule(email: "test@example"))
                    self.shouldFail(rule: IsEmailRule(email: "@example.com"))
                }
            }
            
            context("when long enough string passed") {
                it("succeeds checking for minimal length") {
                    try Validator.validate {
                        HasMinimalLengthRule(value: "abcd1234", length: 8)
                        HasMinimalLengthRule(value: "abcd12345", length: 8)
                    }
                }
            }
            
            context("when small string passed") {
                it("fails") {
                    self.shouldFail(rule: HasMinimalLengthRule(value: "abcd123", length: 8))
                }
            }
        }
    }
}

// MARK: - Private
private extension ValidatorSpec {
    
    func shouldFail(rule: ValidationRule) {
        expect(
            try Validator.validate {
                rule
            }
        ).to(throwError(errorType: ValidationError.self))
    }
}
