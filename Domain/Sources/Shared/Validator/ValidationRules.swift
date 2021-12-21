//
//  ValidationRules.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public protocol ValidationRule {
    var isValid: Bool { get }
}

public struct RegexRule: ValidationRule {
    public let value: String
    public let regex: String
    
    public var isValid: Bool {
        value.range(of: regex, options: .regularExpression) != nil
    }
    
    public init(value: String, regex: String) {
        self.value = value
        self.regex = regex
    }
}

public struct IsEmailRule: ValidationRule {
    public let email: String
    
    private var regexRule: RegexRule {
        RegexRule(value: email, regex: #"^\S+@\S+\.\S+$"#)
    }
    
    public var isValid: Bool {
        regexRule.isValid
    }
    
    public init(email: String) {
        self.email = email
    }
}

public struct HasMinimalLengthRule<T: Collection>: ValidationRule where T: Equatable {
    public let value: T
    public let length: Int
    
    public var isValid: Bool {
        value.count >= length
    }
    
    public init(value: T, length: Int) {
        self.value = value
        self.length = length
    }
}

public struct HasCorrectLengthRule<T: Collection>: ValidationRule where T: Equatable {
    public let value: T
    public let length: Int
    
    public var isValid: Bool {
        value.count == length
    }
    
    public init(value: T, length: Int) {
        self.value = value
        self.length = length
    }
}

public struct AreEqualRule<T: Equatable>: ValidationRule {
    public let first: T
    public let second: T
    
    public var isValid: Bool {
        first == second
    }
    
    public init(first: T, second: T) {
        self.first = first
        self.second = second
    }
}
