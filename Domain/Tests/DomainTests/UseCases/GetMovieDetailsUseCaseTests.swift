//
//  GetMovieDetailsUseCaseTests.swift
//  DomainTests
//
//  Created by Yan Schnaider on 29/12/2021.
//

import XCTest
import Nimble

@testable import Domain

class GetMovieDetailsUseCaseTests: XCTestCase {

    func testShouldSucceed_whenGatewaySucceeded() async throws {
        let movie = Mocks.movieDetails()
        let gateway = SuccessfulGateway(movie: movie)
        let useCase = GetMovieDetailsUseCase(gateway: gateway)
        
        let result = try await useCase.execute(input: .init(id: "2"))
        
        expect(result).to(equal(movie))
    }
    
    func testShouldFail_whenGatewayFailed() async {
        let gateway = FailableGateway()
        let useCase = GetMovieDetailsUseCase(gateway: gateway)
        
        do {
            _ = try await useCase.execute(input: .init(id: "2"))
            fail("Expected to throw while awaiting, but succeeded")
        } catch {
            expect(error as? TestError).to(equal(.generic))
        }
    }
}

// MARK: - Gateways
private extension GetMovieDetailsUseCaseTests {
    
    struct SuccessfulGateway: GetMovieDetailsGateway {
        let movie: MovieDetails
        
        func get(movie: MovieDetails.Get) async throws -> MovieDetails {
            try await Task.sleep(nanoseconds: 30_000_000) // 30 milliseconds
            return self.movie
        }
    }
    
    struct FailableGateway: GetMovieDetailsGateway {
        
        func get(movie: MovieDetails.Get) async throws -> MovieDetails {
            try await Task.sleep(nanoseconds: 30_000_000) // 30 milliseconds
            throw TestError.generic
        }
    }
}

