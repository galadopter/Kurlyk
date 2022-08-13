//
//  File.swift
//  
//
//  Created by Yan Schneider on 08/08/2022.
//

import Foundation

public protocol SaveFavoriteMovieGateway {
    func save(movie: FavoriteMovie) async throws
}

public struct SaveFavoriteMovieUseCase {
    public let gateway: SaveFavoriteMovieGateway
    
    public init(gateway: SaveFavoriteMovieGateway) {
        self.gateway = gateway
    }
}

// MARK: - AsyncThrowingNoInputUseCaseType
extension SaveFavoriteMovieUseCase: AsyncThrowingUseCaseType {
    
    public typealias Output = Void
    
    public func execute(input: FavoriteMovie) async throws {
        try await gateway.save(movie: input)
    }
}
