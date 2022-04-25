//
//  AppEnvironment.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Domain
import AuthenticationFeature
import MoviesListFeature
import ComposableArchitecture

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension AppEnvironment {
    static let live = AppEnvironment(
        mainQueue: .main
    )
    
    var authentication: AuthenticationEnvironment {
        .mock
    }
    
    var moviesList: MoviesListFeatureEnvironment {
        .mock
    }
}
