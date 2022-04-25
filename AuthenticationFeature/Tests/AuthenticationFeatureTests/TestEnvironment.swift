//
//  TestEnvironment.swift
//  AuthenticationFeature
//
//  Created by Yan Schneider on 21.12.21.
//

import Foundation
import Domain
import AuthenticationFeature

extension AuthenticationEnvironment {
    static let test = AuthenticationEnvironment(
        mainQueue: .main,
        createUserGateway: TestCreateUserGateway(),
        getUserGateway: TestGetUserGateway()
    )
}

struct TestCreateUserGateway: CreateUserGateway {
    func create(user: User.Create) async throws { }
}

struct TestGetUserGateway: GetUserGateway {
    func get(user: User.Get) async throws -> User {
        .init(email: "test@example.com", name: "Some", biography: "Something")
    }
}
