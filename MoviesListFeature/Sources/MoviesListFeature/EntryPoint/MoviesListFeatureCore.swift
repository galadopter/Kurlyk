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
    let getPopularMoviesGateway: GetPopularMoviesGateway
    let getMovieDetailsGateway: GetMovieDetailsGateway
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        getPopularMoviesGateway: GetPopularMoviesGateway,
        getMovieDetailsGateway: GetMovieDetailsGateway
    ) {
        self.mainQueue = mainQueue
        self.getPopularMoviesGateway = getPopularMoviesGateway
        self.getMovieDetailsGateway = getMovieDetailsGateway
    }
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
