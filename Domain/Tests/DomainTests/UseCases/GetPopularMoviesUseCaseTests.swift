//
//  GetPopularMoviesUseCaseTests.swift
//  DomainTests
//
//  Created by Yan Schnaider on 29/12/2021.
//

import XCTest
import Nimble

@testable import Domain

class GetPopularMoviesUseCaseTests: XCTestCase {

    func testShouldSucceed_whenGatewaySucceeded() async throws {
        let page = Mocks.moviesPage()
        let gateway = SuccessfulGateway(page: page)
        let useCase = GetPopularMoviesUseCase(gateway: gateway)
        
        let result = try await useCase.execute(input: .init(pageNumber: 1))
        
        expect(result).to(equal(page))
    }
    
    func testShouldFail_whenGatewayFailed() async {
        let gateway = FailableGateway()
        let useCase = GetPopularMoviesUseCase(gateway: gateway)
        
        do {
            _ = try await useCase.execute(input: .init(pageNumber: 2))
            fail("Expected to throw while awaiting, but succeeded")
        } catch {
            expect(error as? TestError).to(equal(.generic))
        }
    }
}

// MARK: - Gateways
private extension GetPopularMoviesUseCaseTests {
    
    struct SuccessfulGateway: GetPopularMoviesGateway {
        let page: MoviesPage
        
        func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
            try await Task.sleep(nanoseconds: 30_000_000) // 30 milliseconds
            return page
        }
    }
    
    struct FailableGateway: GetPopularMoviesGateway {
        
        func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
            try await Task.sleep(nanoseconds: 30_000_000) // 30 milliseconds
            throw TestError.generic
        }
    }
}
