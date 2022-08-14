//
//  MovieDetailsCore.swift
//  
//
//  Created by Yan Schneider on 01/05/2022.
//

import Foundation
import ComposableArchitecture
import Domain
import ComponentsKit

public struct MovieDetailsState: Equatable, Identifiable {
    var isLoadingDetails = false
    var movieID: Domain.MovieDetails.Get
    var movieDetails: MovieDetails?
    var isPerformingFavoriteAction = false
    var errorAlert: AlertState<MoviesListAction>?
    
    public var id: String {
        movieID.id
    }
}

public enum MovieDetailsAction: Equatable {
    case loadDetails
    case receivedDetails(Result<MovieDetails, DomainError>)
    case receivedFavoriteResult(Result<None, DomainError>)
    case changeFavoriteStatus
    case alertDismissed
}

let movieDetailsReducer = Reducer<MovieDetailsState, MovieDetailsAction, MoviesListFeatureEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .loadDetails:
            state.isLoadingDetails = true
            
            let getMovieDetailsUseCase = GetMovieDetailsUseCase(gateway: environment.getMovieDetailsGateway)
            let checkMovieIsFavoriteUseCase = CheckMovieIsFavoriteUseCase(gateway: environment.checkMovieIsFavoriteGateway)
            let movieID = state.movieID
            
            return Effect<MovieDetails, Error>.task {
                async let movieDetails = getMovieDetailsUseCase.execute(input: movieID)
                async let isFavorite = checkMovieIsFavoriteUseCase.execute(input: .init(id: movieID.id))
                let dateFormatter = DateFormatter.medium
                
                return try await .init(domain: movieDetails, isFavorite: isFavorite, dateFormatter: dateFormatter)
            }
            .receive(on: environment.mainQueue)
            .mapError { _ in .generic }
            .catchToEffect(MovieDetailsAction.receivedDetails)
            
        case .receivedDetails(let result):
            state.isLoadingDetails = false
            
            switch result {
            case .success(let details):
                state.movieDetails = details
            case .failure:
                state.errorAlert = errorAlert(message: L10n.Errors.generic)
            }
            
            return .none
        
        case .changeFavoriteStatus:
            guard let movie = state.movieDetails else {
                return .none
            }
            let movieID = state.movieID
            state.isPerformingFavoriteAction = true
            
            return Effect<Void, Error>.task {
                if movie.isFavorite {
                    let useCase = DeleteFavoriteMovieUseCase(gateway: environment.deleteFavoriteMovieGateway)
                    
                    return try await useCase.execute(input: .init(id: movieID.id))
                } else {
                    let useCase = SaveFavoriteMovieUseCase(gateway: environment.saveFavoriteMovieGateway)
                    
                    return try await useCase.execute(input: .init(details: movie, id: movieID.id))
                }
            }
            .receive(on: environment.mainQueue)
            .mapToNone()
            .mapError { _ in .generic }
            .catchToEffect(MovieDetailsAction.receivedFavoriteResult)
            
        case .receivedFavoriteResult(let result):
            state.isPerformingFavoriteAction = false
            
            switch result {
            case .success:
                state.movieDetails?.isFavorite.toggle()
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
