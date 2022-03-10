//
//  WelcomeCore.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation
import Domain
import ComposableArchitecture

public enum WelcomeState: Equatable {
    case initial
    case createUser(CreateUserState)
    case login(LoginState)
    
    init() { self = .initial }
}

public enum WelcomeAction: Equatable {
    case initial
    case createUserTapped
    case createUser(CreateUserAction)
    case loginTapped
    case login(LoginAction)
    case revertState
}

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, AuthenticationEnvironment>.combine(
    createUserReducer
        .pullback(
            state: /WelcomeState.createUser,
            action: /WelcomeAction.createUser,
            environment: { $0 }
        ),
    loginReducer
        .pullback(
            state: /WelcomeState.login,
            action: /WelcomeAction.login,
            environment: { $0 }
        ),
    
    Reducer { state, action, environment in
        switch action {
        case .createUserTapped:
            state = .createUser(.init())
            return .none
        case .loginTapped:
            state = .login(.init())
            return .none
        case .login:
            return .none
        case .createUser:
            return .none
        case .revertState:
            state = .initial
            return .none
        case .initial:
            return .none
        }
    }
)
