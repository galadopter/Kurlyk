//
//  MoviesServiceTests.swift
//  InfrastructureTests
//
//  Created by Yan Schnaider on 27/12/2021.
//

import XCTest
import Domain

@testable import MoviesListAPI

class MoviesServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        StubbedURLProtocol.reset()
    }

    func testShouldCompleteFetchingNowPlayingMoviesWithError_whenNetworkFailed() {
        let sut: GetNowPlayingMoviesGateway = makeSUT()
        
        expectToFail { completion in
            sut.getNowPlayingMovies(page: 1, completion: completion)
        }
    }
    
    func testShouldCompleteFetchingPopularMoviesWithError_whenNetworkFailed() {
        let sut: GetPopularMoviesGateway = makeSUT()
        
        expectToFail { completion in
            sut.getPopularMovies(page: 1, completion: completion)
        }
    }
    
    func testShouldCompleteFetchingMovieDetailsWithError_whenNetworkFailed() {
        let sut: GetMovieDetailsGateway = makeSUT()
        
        expectToFail { completion in
            sut.getMovie(.init(id: "2"), completion: completion)
        }
    }
    
    func testShouldCompleteFetchingNowPlayingMovies_whenReceivedData() {
        let sut: GetNowPlayingMoviesGateway = makeSUT()
        
        StubbedURLProtocol.data = makeResponseData(from: .getNowPlaying)
        StubbedURLProtocol.response = makeHTTPResponse(statusCode: 200)
        let expectation = XCTestExpectation()
        
        sut.getNowPlayingMovies(page: 1) { result in
            let moviesPage = try? result.get()
            XCTAssertEqual(moviesPage?.page, 1)
            XCTAssertEqual(moviesPage?.movies.count, 20)
            XCTAssertEqual(moviesPage?.movies.first?.title, "Suicide Squad")
            XCTAssertEqual(moviesPage?.movies.first?.rating, 5.91)
            XCTAssertEqual(moviesPage?.movies.first?.overview.isEmpty, false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: Timeout.short)
    }
    
    func testShouldCompleteFetchingPopularMovies_whenReceivedData() {
        let sut: GetPopularMoviesGateway = makeSUT()
        
        StubbedURLProtocol.data = makeResponseData(from: .getPopular)
        StubbedURLProtocol.response = makeHTTPResponse(statusCode: 200)
        let expectation = XCTestExpectation()
        
        sut.getPopularMovies(page: 1) { result in
            let moviesPage = try? result.get()
            XCTAssertEqual(moviesPage?.page, 1)
            XCTAssertEqual(moviesPage?.movies.count, 20)
            XCTAssertEqual(moviesPage?.movies.first?.title, "Suicide Squad")
            XCTAssertEqual(moviesPage?.movies.first?.rating, 5.91)
            XCTAssertEqual(moviesPage?.movies.first?.overview.isEmpty, false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: Timeout.short)
    }
    
    func testShouldCompleteFetchingMovieDetails_whenReceivedData() {
        let sut: GetMovieDetailsGateway = makeSUT()
        
        StubbedURLProtocol.data = makeResponseData(from: .getDetails)
        StubbedURLProtocol.response = makeHTTPResponse(statusCode: 200)
        let expectation = XCTestExpectation()
        
        sut.getMovie(.init(id: "1")) { result in
            let movie = try? result.get()
            XCTAssertEqual(movie?.id, "550")
            XCTAssertEqual(movie?.title, "Fight Club")
            XCTAssertEqual(movie?.rating, 7.8)
            XCTAssertEqual(movie?.duration, 139)
            XCTAssertEqual(movie?.genres, [.init(name: "Drama")])
            XCTAssertEqual(movie?.overview.isEmpty, false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: Timeout.short)
    }
}

// MARK: - SUT
private extension MoviesServiceTests {
    
    func makeSUT() -> MoviesService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubbedURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let network = Network<MoviesAPI>(session: session)
        return .init(network: network)
    }
}

// MARK: - Helpers
private extension MoviesServiceTests {
    
    typealias AssertedCompletion<T> = (Result<T, Error>) -> Void
    
    enum ResponseFiles: String {
        case getNowPlaying = "GetNowPlayingMovies"
        case getPopular = "GetPopularMovies"
        case getDetails = "GetMovieDetails"
    }
    
    func expectToFail<T>(task: (@escaping AssertedCompletion<T>) -> Void) {
        StubbedURLProtocol.error = TestError.generic
        let expectation = XCTestExpectation()
        
        task { result in
            XCTAssertNotNil(result.failure)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: Timeout.short)
    }
    
    func makeResponseData(from file: ResponseFiles) -> Data {
        let url = Bundle(for: MoviesServiceTests.self).url(forResource: file.rawValue, withExtension: "json")
        return url.flatMap { try? Data(contentsOf: $0) } ?? Data()
    }
}
