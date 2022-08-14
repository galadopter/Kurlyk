//
//  AppReducer.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation
import ComposableArchitecture
import AuthenticationFeature
import MoviesListFeature
import SwiftUI

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    authenticationReducer
        .pullback(
            state: /AppState.authentication,
            action: /AppAction.authentication,
            environment: { $0.authentication }
        ),
    moviesListFeatureReducer
        .pullback(
            state: /AppState.moviesList,
            action: /AppAction.moviesList,
            environment: { $0.moviesList }
        ),
    
    Reducer { state, action, environment in
        switch action {
        case .authentication(.finished):
            state = .moviesList(.init())
            
            return .none
            
        case .authentication:
            return .none
            
        case .moviesList:
            return .none
        }
    }
)
