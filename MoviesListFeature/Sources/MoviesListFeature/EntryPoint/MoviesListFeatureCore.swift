//
//  MoviesListFeatureCore.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import Domain
import ComposableArchitecture

public enum MoviesListFeatureState: Equatable {
    case moviesList(MoviesListState)
    
    public init() { self = .moviesList(.init()) }
}

public enum MoviesListFeatureAction: Equatable {
    case moviesList(MoviesListAction)
}

public struct MoviesListFeatureEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.mainQueue = mainQueue
    }
}

public extension MoviesListFeatureEnvironment {
    
    /// Mocked environment
    static let mock = MoviesListFeatureEnvironment(
        mainQueue: .main
    )
}

public let moviesListFeatureReducer = Reducer<MoviesListFeatureState, MoviesListFeatureAction, MoviesListFeatureEnvironment>.combine(
    moviesListReducer.pullback(
        state: /MoviesListFeatureState.moviesList,
        action: /MoviesListFeatureAction.moviesList,
        environment: { $0 }
    ),
    
    Reducer { state, action, evironment in
        switch action {
        case .moviesList:
            return .none
        }
    }
)
