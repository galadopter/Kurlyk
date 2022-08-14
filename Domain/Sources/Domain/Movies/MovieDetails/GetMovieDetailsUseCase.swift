//
//  GetMovieDetailsUseCase.swift
//  Domain
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

public protocol GetMovieDetailsGateway {
    func get(movie: MovieDetails.Get) async throws -> MovieDetails
}

public struct GetMovieDetailsUseCase {
    public let gateway: GetMovieDetailsGateway
    
    public init(gateway: GetMovieDetailsGateway) {
        self.gateway = gateway
    }
}

// MARK: - AsyncThrowableUseCaseType
extension GetMovieDetailsUseCase: AsyncThrowingUseCaseType {
    
    public func execute(input: MovieDetails.Get) async throws -> MovieDetails {
        try await gateway.get(movie: input)
    }
}
