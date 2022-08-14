//
//  File.swift
//  
//
//  Created by Yan Schneider on 08/08/2022.
//

import Foundation

public protocol CheckMovieIsFavoriteGateway {
    func isFavorite(movie: FavoriteMovie.IsFavorite) async throws -> Bool
}

public struct CheckMovieIsFavoriteUseCase {
    public let gateway: CheckMovieIsFavoriteGateway
    
    public init(gateway: CheckMovieIsFavoriteGateway) {
        self.gateway = gateway
    }
}

// MARK: - AsyncThrowingUseCaseType
extension CheckMovieIsFavoriteUseCase: AsyncThrowingUseCaseType {
    
    public func execute(input: FavoriteMovie.IsFavorite) async throws -> Bool {
        try await gateway.isFavorite(movie: input)
    }
}
