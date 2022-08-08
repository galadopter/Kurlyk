//
//  File.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import Foundation
import ComposableArchitecture
import Domain
import ComponentsKit

public struct MoviesListState: Equatable {
    var isLoadingMovies = false
    var selectedMovie: MovieDetailsState?
    var popularMovies = [PopularMovie]()
    var popularMoviesCounter = PaginationCounter()
    var errorAlert: AlertState<MoviesListAction>?
}

public enum MoviesListAction: Equatable {
    case movieDetails(MovieDetailsAction)
    case loadNextPage
    case receivedPopularMovies(Result<PaginationUseCase<MoviesPage>.Output, MoviesListError>)
    case selectMovie(_ movie: PopularMovie)
    case dismissMovieDetails
    case alertDismissed
}

public enum MoviesListError: Error {
    case reachedMoviesLimit
    case generic
}

// MARK: - Getters
private let popularMoviesGetter = { (useCase: GetPopularMoviesUseCase) in
    PaginationUseCase<MoviesPage> { pageIndex in
        try await useCase.execute(input: .init(pageNumber: pageIndex))
    }
}

let moviesListReducer = Reducer<MoviesListState, MoviesListAction, MoviesListFeatureEnvironment>.combine(
    movieDetailsReducer
        .optional()
        .pullback(
            state: \.selectedMovie,
            action: /MoviesListAction.movieDetails,
            environment: { $0 }
        ),
    
    Reducer { state, action, environment in
        switch action {
        case .loadNextPage:
            state.isLoadingMovies = true
            
            let useCase = GetPopularMoviesUseCase(gateway: environment.getPopularMoviesGateway)
            let getter = popularMoviesGetter(useCase)
            let counter = state.popularMoviesCounter
            
            return Effect<PaginationUseCase<MoviesPage>.Output, Error>.task {
                try await getter.execute(input: counter)
            }
            .receive(on: environment.mainQueue)
            .mapError { error in
                switch error {
                case PaginationUseCase<MoviesPage>.PaginationError.reachedTheLimit:
                    return .reachedMoviesLimit
                default: return .generic
                }
            }
            .catchToEffect(MoviesListAction.receivedPopularMovies)
            
        case .receivedPopularMovies(let result):
            state.isLoadingMovies = false
            
            switch result {
            case .success(let output):
                let dateFormatter = DateFormatter.medium
                state.popularMoviesCounter = output.pagination
                state.popularMovies += output.result.movies.map {
                    PopularMovie(domain: $0, dateFormatter: dateFormatter)
                }
                
                return .none
            case .failure(.reachedMoviesLimit):
                return .none
            case .failure(.generic):
                state.errorAlert = errorAlert(message: L10n.Errors.generic)
                
                return .none
            }
            
        case .alertDismissed:
            state.errorAlert = nil
            return .none
            
        case .selectMovie(let movie):
            state.selectedMovie = .init(movieID: .init(id: movie.id))
            return .none
            
        case .dismissMovieDetails:
            state.selectedMovie = nil
            return .none
            
        case .movieDetails:
            return .none
        }
    }
)
