//
//  MoviesListCoreTests.swift
//  
//
//  Created by Yan Schneider on 12/08/2022.
//

import XCTest
import ComposableArchitecture
import Domain

@testable import MoviesListFeature

@MainActor
class MoviesListCoreTests: XCTestCase {
    
    func testShouldReceiveMultiplePages_whenStartedLoadingMoviesSeveralTimes() async {
        let store = TestStore(
            initialState: .init(),
            reducer: moviesListReducer,
            environment: .test()
        )
        
        for index in 1...10 {
            let paginationResult = Mocks.paginationPage(result: Mocks.moviesPage(page: index))
            let receivedPopularMovies = (1...10).map {
                Mocks.popularMovie(id: "\(10 * (index - 1) + $0)", title: "\(10 * (index - 1) + $0)")
            }
            
            await store.send(.loadNextPage) {
                $0.isLoadingMovies = true
            }
            
            await store.receive(.receivedPopularMovies(.success(paginationResult))) {
                $0.isLoadingMovies = false
                $0.popularMovies.append(contentsOf: receivedPopularMovies)
                $0.popularMoviesCounter.increment()
                $0.popularMoviesCounter.set(totalPages: 10)
            }
        }
        
        await store.finish()
    }
    
    func testShouldPresentAlert_whenReceivedErrorWhileLoadingMovies() async {
        let store = TestStore(
            initialState: .init(),
            reducer: moviesListReducer,
            environment: .failedTest
        )
        
        await store.send(.loadNextPage) {
            $0.isLoadingMovies = true
        }
        
        await store.receive(.receivedPopularMovies(.failure(.generic))) {
            $0.isLoadingMovies = false
            $0.errorAlert = .init(title: TextState("Error"), message: TextState(L10n.Errors.generic))
        }
        
        await store.send(.alertDismissed) {
            $0.errorAlert = nil
        }
        
        await store.finish()
    }
    
    func testShouldDoNothing_whenReceivedNoMorePagesError() async {
        let store = TestStore(
            initialState: .init(),
            reducer: moviesListReducer,
            environment: .test(getPopularMoviesGateway: .init(totalPages: 1))
        )
        let paginationResult = Mocks.paginationPage(result: Mocks.moviesPage(page: 1, totalPages: 1))
        let receivedPopularMovies = (1...10).map {
            Mocks.popularMovie(id: "\($0)", title: "\($0)")
        }
        
        await store.send(.loadNextPage) {
            $0.isLoadingMovies = true
        }
        
        await store.receive(.receivedPopularMovies(.success(paginationResult))) {
            $0.isLoadingMovies = false
            $0.popularMovies.append(contentsOf: receivedPopularMovies)
            $0.popularMoviesCounter.increment()
            $0.popularMoviesCounter.set(totalPages: 1)
        }
        
        await store.send(.loadNextPage) {
            $0.isLoadingMovies = true
        }
        
        await store.receive(.receivedPopularMovies(.failure(.reachedMoviesLimit))) {
            $0.isLoadingMovies = false
        }
        
        await store.finish()
    }
    
    func testShouldPresentMovieDetails_whenMovieSelected() async {
        let store = TestStore(
            initialState: .init(),
            reducer: moviesListReducer,
            environment: .test()
        )
        
        await store.send(.selectMovie(Mocks.popularMovie(id: "123"))) {
            $0.selectedMovie = .init(movieID: .init(id: "123"))
        }
        
        await store.send(.dismissMovieDetails) {
            $0.selectedMovie = nil
        }
        
        await store.finish()
    }
}
