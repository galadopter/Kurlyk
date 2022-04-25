//
//  AppState.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation
import AuthenticationFeature
import MoviesListFeature

enum AppState: Equatable {
    case authentication(AuthenticationState)
    case moviesList(MoviesListFeatureState)
    
    init() { self = .authentication(.init()) }
}
