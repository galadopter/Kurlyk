//
//  CreateUserUseCaseTests.swift
//  DomainTests
//
//  Created by Yan Schneider on 15.11.21.
//

import XCTest
import Domain
import Nimble

class CreateUserUseCaseTests: XCTestCase {

    func testShouldSucceed_whenGatewaySucceeded() async throws {
        let user = Mocks.createUser()
        let gateway = SuccessfulGateway()
        let sut = CreateUserUseCase(gateway: gateway)

        try await sut.execute(input: user)
    }

    func testShouldFail_whenGatewayFailed() async throws {
        let user = Mocks.createUser()
        let gateway = FailableGateway()
        let sut = CreateUserUseCase(gateway: gateway)

        do {
            try await sut.execute(input: user)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            expect(error as? TestError).to(equal(.generic))
        }
    }
}

// MARK: - Mocks
extension CreateUserUseCaseTests {

    struct SuccessfulGateway: CreateUserGateway {

        func create(user: User.Create) async throws {

        }
    }

    struct FailableGateway: CreateUserGateway {

        func create(user: User.Create) async throws {
            throw Mocks.error()
        }
    }
}
