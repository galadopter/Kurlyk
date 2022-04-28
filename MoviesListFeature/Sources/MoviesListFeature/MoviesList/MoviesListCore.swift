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
    var popularMovies = [PopularMovie]()
    var popularMoviesCounter = PaginationCounter()
    var errorAlert: AlertState<MoviesListAction>?
}

public enum MoviesListAction: Equatable {
    case loadNextPage
    case receivedPopularMovies(Result<PaginationUseCase<MoviesPage>.Output, MoviesListError>)
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
                state.popularMoviesCounter = output.pagination
                state.popularMovies += output.result.movies.map {
                    PopularMovie(domain: $0, dateFormatter: DateFormatter())
                }
                return .none
            case .failure(.reachedMoviesLimit):
                return .none
            case .failure(.generic):
                state.errorAlert = errorAlert(message: "Something went wrong!")
                return .none
            }
            
        case .alertDismissed:
            state.errorAlert = nil
            return .none
        }
    }
)
