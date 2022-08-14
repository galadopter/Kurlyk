//
//  MovieDetailsCoreTests.swift
//  
//
//  Created by Yan Schneider on 13/08/2022.
//

import XCTest
import Domain
import Nimble
import ComposableArchitecture

@testable import MoviesListFeature

@MainActor
class MovieDetailsCoreTests: XCTestCase {
    
    func testShouldSaveID_whenMovieIDPassed() async {
        let movieID = Domain.MovieDetails.Get(id: "123")
        let store = TestStore(
            initialState: .init(movieID: movieID),
            reducer: movieDetailsReducer,
            environment: .test()
        )
        
        expect(store.state.id).to(equal(movieID.id))
    }

    func testShouldReceiveDetails_whenStartedLoading() async {
        let movieID = Domain.MovieDetails.Get(id: "123")
        let details = Mocks.movieDetails(title: "123")
        let store = TestStore(
            initialState: .init(movieID: movieID),
            reducer: movieDetailsReducer,
            environment: .test()
        )
        
        await store.send(.loadDetails) {
            $0.isLoadingDetails = true
        }
        
        await store.receive(.receivedDetails(.success(details))) {
            $0.isLoadingDetails = false
            $0.movieDetails = details
        }
        
        await store.finish()
    }
    
    func testShouldPresentAlert_whenLoadingDetailsFailed() async {
        let movieID = Domain.MovieDetails.Get(id: "123")
        let store = TestStore(
            initialState: .init(movieID: movieID),
            reducer: movieDetailsReducer,
            environment: .failedTest
        )
        
        await store.send(.loadDetails) {
            $0.isLoadingDetails = true
        }
        
        await store.receive(.receivedDetails(.failure(.generic))) {
            $0.isLoadingDetails = false
            $0.errorAlert = .init(title: TextState("Error"), message: TextState(L10n.Errors.generic))
        }
        
        await store.send(.alertDismissed) {
            $0.errorAlert = nil
        }
        
        await store.finish()
    }
    
    func testShouldSaveInFavorites_whenSendFavoriteAction() async {
        let movieID = Domain.MovieDetails.Get(id: "123")
        let details = Mocks.movieDetails(title: "123")
        let store = TestStore(
            initialState: .init(movieID: movieID),
            reducer: movieDetailsReducer,
            environment: .test()
        )
        
        await store.send(.loadDetails) {
            $0.isLoadingDetails = true
        }
        
        await store.receive(.receivedDetails(.success(details))) {
            $0.isLoadingDetails = false
            $0.movieDetails = details
        }
        
        await store.send(.changeFavoriteStatus) {
            $0.isPerformingFavoriteAction = true
        }
        
        await store.receive(.receivedFavoriteResult(.success(.init()))) {
            $0.isPerformingFavoriteAction = false
            $0.movieDetails?.isFavorite = true
        }
        
        await store.finish()
    }
    
    func testShouldPresentAlert_whenSendingFavoriteStatusFailed() async {
        let movieID = Domain.MovieDetails.Get(id: "123")
        let details = Mocks.movieDetails(title: "123")
        let store = TestStore(
            initialState: .init(movieID: movieID),
            reducer: movieDetailsReducer,
            environment: .test()
        )
        
        await store.send(.loadDetails) {
            $0.isLoadingDetails = true
        }
        
        await store.receive(.receivedDetails(.success(details))) {
            $0.isLoadingDetails = false
            $0.movieDetails = details
        }
        
        store.environment = .failedTest
        
        await store.send(.changeFavoriteStatus) {
            $0.isPerformingFavoriteAction = true
        }
        
        await store.receive(.receivedFavoriteResult(.failure(.generic))) {
            $0.isPerformingFavoriteAction = false
            $0.errorAlert = .init(title: TextState("Error"), message: TextState(L10n.Errors.generic))
        }
        
        await store.finish()
    }
}
