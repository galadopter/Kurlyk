//
//  FavoriteMoviesListCoreTests.swift
//  
//
//  Created by Yan Schneider on 14/08/2022.
//

import XCTest
import ComposableArchitecture

@testable import MoviesListFeature

@MainActor
class FavoriteMoviesListCoreTests: XCTestCase {

    func testShouldReceiveNoFavoriteMovies_whenStartedLoadingWithoutSaving() async throws {
        let store = TestStore(
            initialState: .init(),
            reducer: favoriteMoviesReducer,
            environment: .test()
        )
        
        await store.send(.loadFavoriteMovies) {
            $0.isLoadingFavoriteMovies = true
        }
        
        await store.receive(.receivedFavoriteMovies(.success([]))) {
            $0.isLoadingFavoriteMovies = false
        }
        
        await store.finish()
    }
    
    func testShouldReceiveFavoriteMovies_whenLoadedWithSaving() async throws {
        let gateway = SuccessfulFavoriteMovieGateway()
        let movie = Mocks.favoriteMovie(id: "123", title: "Blade Runner")
        let store = TestStore(
            initialState: .init(),
            reducer: favoriteMoviesReducer,
            environment: .test(favoriteMoviesGateway: gateway)
        )
        
        try await gateway.save(movie: movie)
        
        await store.send(.loadFavoriteMovies) {
            $0.isLoadingFavoriteMovies = true
        }
        
        await store.finish()
        
        await store.receive(.receivedFavoriteMovies(.success([movie]))) {
            $0.isLoadingFavoriteMovies = false
            $0.favoriteMovies.append(movie)
        }
        
        await store.finish()
    }
    
    func testShouldReceiveMoviesMultipleTimes_whenContiniouslySavingMovies() async throws {
        let gateway = SuccessfulFavoriteMovieGateway()
        let movies = (1...10).map { Mocks.favoriteMovie(id: "\($0)", title: "\($0)") }
        let store = TestStore(
            initialState: .init(),
            reducer: favoriteMoviesReducer,
            environment: .test(favoriteMoviesGateway: gateway)
        )
        
        // First movie
        try await gateway.save(movie: movies[0])
        
        await store.send(.loadFavoriteMovies) {
            $0.isLoadingFavoriteMovies = true
        }
        
        await store.receive(.receivedFavoriteMovies(.success([movies[0]]))) {
            $0.isLoadingFavoriteMovies = false
            $0.favoriteMovies.append(movies[0])
        }
        
        await store.finish()
        
        // Second and third movie
        try await gateway.save(movie: movies[1])
        try await gateway.save(movie: movies[2])
        
        await store.send(.loadFavoriteMovies) {
            $0.isLoadingFavoriteMovies = true
        }
        
        await store.receive(.receivedFavoriteMovies(.success(Array(movies[...2])))) {
            $0.isLoadingFavoriteMovies = false
            $0.favoriteMovies.append(contentsOf: movies[1...2])
        }
        
        await store.finish()
        
        // Rest of the movies
        for movie in movies[3...] {
            try await gateway.save(movie: movie)
        }
        
        await store.send(.loadFavoriteMovies) {
            $0.isLoadingFavoriteMovies = true
        }
        
        await store.receive(.receivedFavoriteMovies(.success(movies))) {
            $0.isLoadingFavoriteMovies = false
            $0.favoriteMovies.append(contentsOf: movies[3...])
        }
        
        await store.finish()
    }
    
    func testShouldPresentAlert_whenReceiveError() async {
        let store = TestStore(
            initialState: .init(),
            reducer: favoriteMoviesReducer,
            environment: .failedTest
        )
        
        await store.send(.loadFavoriteMovies) {
            $0.isLoadingFavoriteMovies = true
        }
        
        await store.receive(.receivedFavoriteMovies(.failure(.generic))) {
            $0.isLoadingFavoriteMovies = false
            $0.errorAlert = .init(title: TextState("Error"), message: TextState(L10n.Errors.generic))
        }
        
        await store.send(.alertDismissed) {
            $0.errorAlert = nil
        }
        
        await store.finish()
    }
}
