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
    var errorAlert: AlertState<MoviesListAction>?
    
    public var id: String {
        movieID.id
    }
}

public enum MovieDetailsAction: Equatable {
    case loadDetails
    case receivedDetails(Result<Domain.MovieDetails, DomainError>)
    case alertDismissed
}

let movieDetailsReducer = Reducer<MovieDetailsState, MovieDetailsAction, MoviesListFeatureEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .loadDetails:
            state.isLoadingDetails = true
            
            let useCase = GetMovieDetailsUseCase(gateway: environment.getMovieDetailsGateway)
            let movieID = state.movieID
            
            return Effect<Domain.MovieDetails, Error>.task {
                try await useCase.execute(input: movieID)
            }
            .receive(on: environment.mainQueue)
            .mapError { _ in .generic }
            .catchToEffect(MovieDetailsAction.receivedDetails)
            
        case .receivedDetails(let result):
            state.isLoadingDetails = false
            
            switch result {
            case .success(let details):
                let dateFormatter = DateFormatter.medium
                state.movieDetails = .init(domain: details, dateFormatter: dateFormatter)
                
                return .none
            case .failure:
                state.errorAlert = errorAlert(message: "Something went wrong!")
                
                return .none
            }
            
        case .alertDismissed:
            state.errorAlert = nil
            return .none
        }
    }
)
