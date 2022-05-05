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

public extension MoviesListFeatureEnvironment {
    
    /// Mocked environment
    static let mock = MoviesListFeatureEnvironment(
        mainQueue: .main,
        getPopularMoviesGateway: MockedGetPopularMoviesGateway(),
        getMovieDetailsGateway: MockedMovieDetailsGateway()
    )
}

class MockedGetPopularMoviesGateway: GetPopularMoviesGateway {
    let bladeRunnerPoster = URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!
    var page = 0
    
    func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
        try await Task.sleep(nanoseconds: 500_000_000)
        page += 1
        let movies: [MoviesPage.Movie] = (1...10).map {
            .init(id: UUID().uuidString, title: "\((10 * (page - 1)) + $0)", overview: "", rating: 0.95, posterURL: bladeRunnerPoster, releaseDate: .now)
        }
        return .init(page: page, totalPages: 10, movies: movies)
    }
}

struct MockedMovieDetailsGateway: GetMovieDetailsGateway {
    let bladeRunnerPoster = URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!
    
    func get(movie: Domain.MovieDetails.Get) async throws -> Domain.MovieDetails {
        try await Task.sleep(nanoseconds: 500_000_000)
        return .init(id: movie.id, title: "", overview: "", rating: 0, duration: 0, releaseDate: nil, posterURL: bladeRunnerPoster, genres: [])
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
