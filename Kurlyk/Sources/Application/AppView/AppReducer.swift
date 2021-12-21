//
//  AppReducer.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation
import ComposableArchitecture
import AuthenticationFeature

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    authenticationReducer
        .pullback(
            state: /AppState.authentication,
            action: /AppAction.authentication,
            environment: { $0.authentication }
        ),
    
    Reducer { state, action, environment in
        switch action {
        case .authentication:
            return .none
        default:
            return .none
        }
    }
)
