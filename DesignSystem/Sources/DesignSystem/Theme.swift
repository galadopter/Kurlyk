//
//  File.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import Foundation

@dynamicMemberLookup
public class Theme {
    
    private var provider: any ThemeProvider
    
    public init(provider: any ThemeProvider) {
        self.provider = provider
    }
    
    /// Default version of `Theme`. However it's still can be customized bt overriding values in it.
    public static var `default` = Theme(provider: DefaultThemeProvider())
    
    public subscript<T>(dynamicMember keyPath: KeyPath<any ThemeProvider, T>) -> T {
        provider[keyPath: keyPath]
    }
    
    public func update<T>(keyPath: WritableKeyPath<any ThemeProvider, T>, withValue newValue: T) {
        provider[keyPath: keyPath] = newValue
    }
}
