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
    
    init() { self = .initial }
}

public enum WelcomeAction: Equatable {
    case initial
    case createUserTapped
    case createUser(CreateUserAction)
    case login
    case revertState
}

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, AuthenticationEnvironment>.combine(
    createUserReducer
        .pullback(
            state: /WelcomeState.createUser,
            action: /WelcomeAction.createUser,
            environment: { $0 }
        ),
    
    Reducer { state, action, environment in
        switch action {
        case .createUserTapped:
            state = .createUser(.init())
            return .none
        case .login:
            print("login")
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
