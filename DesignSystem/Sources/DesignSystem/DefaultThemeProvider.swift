//
//  DefaultThemeProvider.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import Foundation

public struct DefaultThemeProvider: ThemeProvider {
    
    /// Default values for colors
    public var colors: Theme.Colors
    
    /// Default values for button styles
    public var buttonStyles: Theme.ButtonStyles
    
    /// Default values for sizes
    public var sizes: Theme.Sizes
    
    /// Sets the default values to the theme provider.
    public init() {
        colors = Self.defaultColors()
        sizes = Self.defaultSizes()
        buttonStyles = Self.defaultButtonStyles(colors: colors, sizes: sizes)
    }
}


// MARK: - Private initialization
private extension DefaultThemeProvider {
    
    static func defaultColors() -> Theme.Colors {
        .init(
            primary: .init(rgb: 0xfcd052),
            text: .init(
                primary: .init(rgb: 0xffffff),
                secondary: .init(rgb: 0x212121)
            ),
            background: .init(rgb: 0x212121)
        )
    }
    
    static func defaultButtonStyles(
        colors: Theme.Colors,
        sizes: Theme.Sizes
    ) -> Theme.ButtonStyles {
        .init(
            primary: .init(
                foregroundColor: colors.text.primary,
                backgroundColor: colors.background
            ),
            secondary: .init(
                foregroundColor: colors.text.secondary,
                borderColor: colors.background,
                borderWidth: sizes.xxs
            )
        )
    }
    
    static func defaultSizes() -> Theme.Sizes {
        .init(
            xxs: 2,
            xs: 4,
            sm: 8,
            md: 16,
            lg: 24,
            xl: 32,
            xxl: 48
        )
    }
}
