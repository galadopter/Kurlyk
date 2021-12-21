//
//  ValidateEntityUseCase.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public struct ValidateEntityUseCase<Entity> {
    public let rulesBuilder: (Entity) -> [ValidationRule]
    
    public init(@ValidationBuilder rulesBuilder: @escaping (Entity) -> [ValidationRule]) {
        self.rulesBuilder = rulesBuilder
    }
}

// MARK: - ThrowableUseCaseType
extension ValidateEntityUseCase: ThrowableUseCaseType {
    
    public func execute(input: Entity) throws {
        let rules = rulesBuilder(input)
        try Validator.validate(rules: rules)
    }
}
