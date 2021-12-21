//
//  AppEnvironment.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Domain
import AuthenticationFeature
import ComposableArchitecture

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension AppEnvironment {
    static let live = AppEnvironment(
        mainQueue: .main
    )
    
    var authentication: AuthenticationEnvironment {
        .init(
            mainQueue: mainQueue,
            createUserGateway: MockedCreateUserGateway()
        )
    }
}

struct MockedCreateUserGateway: CreateUserGateway {
    
    func create(user: User.Create) async throws {
        try await Task.sleep(nanoseconds: 3_000_000_000)
    }
}
