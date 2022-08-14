//
//  FavoriteMoviesListCore.swift
//  
//
//  Created by Yan Schneider on 10/08/2022.
//

import Foundation
import ComposableArchitecture
import ComponentsKit
import Domain

public struct FavoriteMoviesListState: Equatable {
    var isLoadingFavoriteMovies = false
    var favoriteMovies = [FavoriteMovie]()
    var errorAlert: AlertState<FavoriteMoviesListAction>?
}

public enum FavoriteMoviesListAction: Equatable {
    case loadFavoriteMovies
    case receivedFavoriteMovies(Result<[FavoriteMovie], DomainError>)
    case alertDismissed
}

let favoriteMoviesReducer = Reducer<FavoriteMoviesListState, FavoriteMoviesListAction, MoviesListFeatureEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .loadFavoriteMovies:
            state.isLoadingFavoriteMovies = true
            
            let useCase = GetFavoriteMoviesUseCase(gateway: environment.getFavoriteMoviesGateway)
            
            return Effect<[FavoriteMovie], Error>.task {
                try await useCase.execute()
            }
            .receive(on: environment.mainQueue)
            .mapError { _ in .generic }
            .catchToEffect(FavoriteMoviesListAction.receivedFavoriteMovies)
            
        case .receivedFavoriteMovies(let result):
            state.isLoadingFavoriteMovies = false
            
            switch result {
            case .success(let movies):
                state.favoriteMovies = movies
            case .failure:
                state.errorAlert = errorAlert(message: L10n.Errors.generic)
            }
            
            return .none
        case .alertDismissed:
            state.errorAlert = nil
            return .none
        }
    }
)
