//
//  EntryCore.swift
//  AuthenticationFeature
//
//  Created by Yan Schneider on 26.11.21.
//

import Domain
import ComposableArchitecture

public enum AuthenticationState: Equatable {
    case welcome(WelcomeState)
    
    public init() { self = .welcome(.init()) }
}

public enum AuthenticationAction: Equatable {
    case welcome(WelcomeAction)
}

public struct AuthenticationEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let createUserGateway: CreateUserGateway
    
    public init(mainQueue: AnySchedulerOf<DispatchQueue>, createUserGateway: CreateUserGateway) {
        self.mainQueue = mainQueue
        self.createUserGateway = createUserGateway
    }
}

public extension AuthenticationEnvironment {
    static let mock = AuthenticationEnvironment(
        mainQueue: .main,
        createUserGateway: MockedCreateUserGateway()
    )
}

struct MockedCreateUserGateway: CreateUserGateway {
    
    func create(user: User.Create) async throws {
        try await Task.sleep(nanoseconds: 2_000_000_000)
    }
}

public var authenticationReducer = Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment>.combine(
    welcomeReducer.pullback(
        state: /AuthenticationState.welcome,
        action: /AuthenticationAction.welcome,
        environment: { $0 }
    ),
    
    Reducer { state, action, evironment in
        switch action {
        case .welcome:
            return .none
        }
    }
)
