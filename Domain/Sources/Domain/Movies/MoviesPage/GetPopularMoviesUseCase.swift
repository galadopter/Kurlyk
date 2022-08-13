//
//  GetPopularMoviesUseCase.swift
//  Domain
//
//  Created by Yan Schnaider on 28/12/2021.
//

import Foundation

public protocol GetPopularMoviesGateway {
    func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage
}

public struct GetPopularMoviesUseCase {
    public let gateway: GetPopularMoviesGateway
    
    public init(gateway: GetPopularMoviesGateway) {
        self.gateway = gateway
    }
}

// MARK: - AsyncThrowableUseCaseType
extension GetPopularMoviesUseCase: AsyncThrowingUseCaseType {
    
    public func execute(input: MoviesPage.Get) async throws -> MoviesPage {
        try await gateway.get(popularMovies: input)
    }
}
