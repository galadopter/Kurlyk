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
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        getPopularMoviesGateway: GetPopularMoviesGateway
    ) {
        self.mainQueue = mainQueue
        self.getPopularMoviesGateway = getPopularMoviesGateway
    }
}

public extension MoviesListFeatureEnvironment {
    
    /// Mocked environment
    static let mock = MoviesListFeatureEnvironment(
        mainQueue: .main,
        getPopularMoviesGateway: MockedGetPopularMoviesGateway()
    )
}

class MockedGetPopularMoviesGateway: GetPopularMoviesGateway {
    let bladeRunnerPoster = URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!
    var page = 0
    
    func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
        try await Task.sleep(nanoseconds: 500_000_000)
        page += 1
        return .init(page: page, totalPages: 10, movies: (1...10).map { .init(id: UUID().uuidString, title: "\((10 * (page - 1)) + $0)", overview: "", rating: 0.95, posterURL: bladeRunnerPoster, releaseDate: .now) })
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
