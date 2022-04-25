//
//  File.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import Foundation
import ComposableArchitecture

public struct MoviesListState: Equatable {
    var isLoadingMovies = false
}

public enum MoviesListAction: Equatable {
    case loadMovies
}

let moviesListReducer = Reducer<MoviesListState, MoviesListAction, MoviesListFeatureEnvironment>.combine(
    
    Reducer { state, action, environment in
        switch action {
        case .loadMovies:
            return .none
        }
    }
)
