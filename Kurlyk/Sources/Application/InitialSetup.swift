//
//  InitialSetup.swift
//  Kurlyk
//
//  Created by Yan Schneider on 28/04/2022.
//

import Foundation
import MoviesListAPI

struct InitialSetup {
    
    static func run() {
        initializeMoviesAPI()
    }
}

// MARK: - Movies API Credentials
private extension InitialSetup {
    
    static func initializeMoviesAPI() {
        MoviesListAPI.Credentials.initialize(
            apiKey: "55957fcf3ba81b137f8fc01ac5a31fb5",
            baseURL: URL(string: "https://api.themoviedb.org/3")!,
            imagesBaseURL: URL(string: "https://image.tmdb.org/t/p/w185")!
        )
    }
}
