//
//  ValidationBuilder.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

@resultBuilder
public struct ValidationBuilder {
    
    public static func buildBlock(_ components: ValidationRule...) -> [ValidationRule] {
        components
    }
    
    public static func buildArray(_ components: [[ValidationRule]]) -> [ValidationRule] {
        components.flatMap { $0 }
    }
    
    public static func buildEither(first component: [ValidationRule]) -> [ValidationRule] {
        component
    }
    
    public static func buildEither(second component: [ValidationRule]) -> [ValidationRule] {
        component
    }
}
