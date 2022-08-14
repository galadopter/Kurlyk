//
//  GetUserUseCase.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public protocol GetUserGateway {
    func get(user: User.Get) async throws -> User
}

public struct GetUserUseCase {
    public let gateway: GetUserGateway
    
    public init(gateway: GetUserGateway) {
        self.gateway = gateway
    }
}

// MARK: - AsyncThrowableUseCaseType
extension GetUserUseCase: AsyncThrowingUseCaseType {
    
    public func execute(input: User.Get) async throws -> User {
        try await gateway.get(user: input)
    }
}
