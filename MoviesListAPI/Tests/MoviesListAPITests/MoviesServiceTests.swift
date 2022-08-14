//
//  MoviesServiceTests.swift
//  InfrastructureTests
//
//  Created by Yan Schnaider on 27/12/2021.
//

import XCTest
import Domain
import NetworkKit
import Nimble

@testable import MoviesListAPI

class MoviesServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        StubbedURLProtocol.reset()
    }
    
    func testShouldCompleteFetchingPopularMoviesWithError_whenNetworkFailed() async {
        let sut: GetPopularMoviesGateway = makeSUT()

        StubbedURLProtocol.error = Network<MoviesAPI>.NetworkError.noConnection
        
        do {
            _ = try await sut.get(popularMovies: .init(pageNumber: 1))
        } catch {
            expect(error as? Network<MoviesAPI>.NetworkError).to(equal(.noConnection))
        }
    }
    
    func testShouldCompleteFetchingMovieDetailsWithError_whenNetworkFailed() async {
        let sut: GetMovieDetailsGateway = makeSUT()
        
        StubbedURLProtocol.error = Network<MoviesAPI>.NetworkError.noConnection
        
        do {
            _ = try await sut.get(movie: .init(id: "2"))
        } catch {
            expect(error as? Network<MoviesAPI>.NetworkError).to(equal(.noConnection))
        }
    }
    
    func testShouldCompleteFetchingPopularMovies_whenReceivedData() async throws {
        let sut: GetPopularMoviesGateway = makeSUT()
        
        StubbedURLProtocol.data = makeResponseData(from: .getPopular)
        StubbedURLProtocol.response = makeHTTPResponse(statusCode: 200)
        
        let response = try await sut.get(popularMovies: .init(pageNumber: 1))
        
        expect(response.page).to(equal(1))
        expect(response.movies).to(haveCount(20))
        expect(response.movies.first?.title).to(equal("Suicide Squad"))
        expect(response.movies.first?.rating).to(equal(0.591))
        expect(response.movies.first?.overview.isEmpty).to(beFalse())
    }
    
    func testShouldCompleteFetchingMovieDetails_whenReceivedData() async throws {
        let sut: GetMovieDetailsGateway = makeSUT()
        
        StubbedURLProtocol.data = makeResponseData(from: .getDetails)
        StubbedURLProtocol.response = makeHTTPResponse(statusCode: 200)
        
        let response = try await sut.get(movie: .init(id: "1"))
        
        expect(response.id).to(equal("550"))
        expect(response.title).to(equal("Fight Club"))
        expect(response.rating).to(equal(0.78))
        expect(response.duration).to(equal(139))
        expect(response.genres).to(equal([.init(name: "Drama")]))
        expect(response.overview.isEmpty).to(beFalse())
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
    
    enum ResponseFiles: String {
        case getPopular = "GetPopularMovies"
        case getDetails = "GetMovieDetails"
    }
    
    func makeResponseData(from file: ResponseFiles) -> Data {
        let url = Bundle.module.url(forResource: file.rawValue, withExtension: "json")
        return url.flatMap { try? Data(contentsOf: $0) } ?? Data()
    }
}
