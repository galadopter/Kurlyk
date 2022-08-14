//
//  File.swift
//  
//
//  Created by Yan Schneider on 08/08/2022.
//

import Foundation

public protocol GetFavoriteMoviesGateway {
    func get() async throws -> [FavoriteMovie]
}

public struct GetFavoriteMoviesUseCase {
    public let gateway: GetFavoriteMoviesGateway
    
    public init(gateway: GetFavoriteMoviesGateway) {
        self.gateway = gateway
    }
}

// MARK: - AsyncThrowingNoInputUseCaseType
extension GetFavoriteMoviesUseCase: AsyncThrowingNoInputUseCaseType {
    
    public func execute() async throws -> [FavoriteMovie] {
        try await gateway.get()
    }
}
