//
//  File.swift
//  
//
//  Created by Yan Schneider on 08/08/2022.
//

import Foundation

public protocol DeleteFavoriteMovieGateway {
    func delete(movie: FavoriteMovie.Delete) async throws
}

public struct DeleteFavoriteMovieUseCase {
    public let gateway: DeleteFavoriteMovieGateway
    
    public init(gateway: DeleteFavoriteMovieGateway) {
        self.gateway = gateway
    }
}

// MARK: - AsyncThrowingUseCaseType
extension DeleteFavoriteMovieUseCase: AsyncThrowingUseCaseType {
    
    public typealias Output = Void
    
    public func execute(input: FavoriteMovie.Delete) async throws {
        try await gateway.delete(movie: input)
    }
}
