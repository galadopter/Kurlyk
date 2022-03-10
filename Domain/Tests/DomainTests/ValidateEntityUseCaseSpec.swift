//
//  ValidateEntityUseCaseSpec.swift
//  DomainTests
//
//  Created by Yan Schneider on 16.11.21.
//

import XCTest
import Domain
import Quick
import Nimble

class ValidateEntityUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("validating entity with use case") {
            context("when validation succeeds") {
                it("succeeds") {
                    let sut = self.makeSUT()
                    
                    try sut.execute(input: Mocks.createUser())
                }
            }
            
            context("when validation fails") {
                it("fails") {
                    let sut = self.makeSUT()
                    
                    expect(
                        try sut.execute(input: .init(email: "", password: "", name: "", biography: ""))
                    ).to(throwError(errorType: ValidationError.self))
                }
            }
        }
    }
}

// MARK: - Private
private extension ValidateEntityUseCaseSpec {
    
    func makeSUT() -> ValidateEntityUseCase<User.Create> {
        .init { user in
            IsEmailRule(email: user.email)
            HasMinimalLengthRule(value: user.password, length: 8)
        }
    }
}
