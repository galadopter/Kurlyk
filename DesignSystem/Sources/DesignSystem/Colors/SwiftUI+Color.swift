//
//  SwiftUI+Color.swift
//  
//
//  Created by Yan Schneider on 1.02.22.
//

import SwiftUI

// MARK: - Additional View methods
public extension View {
    
    @inlinable func foregroundColor(_ color: Color) -> some View {
        foregroundColor(color.swiftUIColor)
    }

    @inlinable func background(_ color: Color) -> some View {
        background(color.swiftUIColor)
    }
    
    /// Accent color modifier with DesignSystem support.
    ///
    /// - Parameter accentColor: The color to use as an accent color. Set the
    ///   value to `nil` to use the inherited accent color.
    @inlinable func accentColor(_ color: Color) -> some View {
        accentColor(color.swiftUIColor)
    }
    
    /// Tint modifier with DesignSystem support.
    ///
    /// - Parameter tint: The tint ``Color`` to apply.
    @inlinable func tint(_ tint: Color) -> some View {
        self.tint(tint.swiftUIColor)
    }
}

// MARK: - SwiftUI Color extension
extension SwiftUI.Color {
    
    static func design(_ color: Color) -> SwiftUI.Color {
        color.swiftUIColor
    }
}
