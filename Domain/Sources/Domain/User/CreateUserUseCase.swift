//
//  CreateUserUseCase.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public protocol CreateUserGateway {
    func create(user: User.Create) async throws
}

public struct CreateUserUseCase {
    public let gateway: CreateUserGateway
    
    public init(gateway: CreateUserGateway) {
        self.gateway = gateway
    }
}

// MARK: AsyncThrowableUseCaseType
extension CreateUserUseCase: AsyncThrowingUseCaseType {
    
    public func execute(input: User.Create) async throws {
        try await gateway.create(user: input)
    }
}
