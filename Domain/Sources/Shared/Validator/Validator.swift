//
//  Validator.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public enum Validator {

    public static func validate(@ValidationBuilder rulesBuilder: () -> [ValidationRule]) throws {
        let rules = rulesBuilder()
        try validate(rules: rules)
    }
    
    public static func validate(rules: [ValidationRule]) throws {
        try rules.forEach { rule in
            guard !rule.isValid else { return }
            throw ValidationError.ruleIsInvalid(rule: rule)
        }
    }
}
