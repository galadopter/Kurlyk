//
//  ValidationError.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public enum ValidationError: Error {
    case ruleIsInvalid(rule: ValidationRule)
}
