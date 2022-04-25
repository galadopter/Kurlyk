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
    case finished
}

public struct AuthenticationEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let createUserGateway: CreateUserGateway
    let getUserGateway: GetUserGateway
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        createUserGateway: CreateUserGateway,
        getUserGateway: GetUserGateway
    ) {
        self.mainQueue = mainQueue
        self.createUserGateway = createUserGateway
        self.getUserGateway = getUserGateway
    }
}

public extension AuthenticationEnvironment {
    
    /// Mocked environment
    static let mock = AuthenticationEnvironment(
        mainQueue: .main,
        createUserGateway: MockedCreateUserGateway(),
        getUserGateway: MockedGetUserGateway()
    )
}

struct MockedCreateUserGateway: CreateUserGateway {
    
    func create(user: User.Create) async throws {
        try await Task.sleep(nanoseconds: 2_000_000_000)
    }
}

struct MockedGetUserGateway: GetUserGateway {
    
    func get(user: User.Get) async throws -> User {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(email: "user@test.com", name: "Some Body", biography: "Test user")
    }
}

public let authenticationReducer = Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment>.combine(
    welcomeReducer.pullback(
        state: /AuthenticationState.welcome,
        action: /AuthenticationAction.welcome,
        environment: { $0 }
    ),
    
    Reducer { state, action, evironment in
        switch action {
        case .welcome(.login(.loginSucceeded)):
            return .init(value: .finished)
        case .welcome:
            return .none
        case .finished:
            return .none
        }
    }
)
