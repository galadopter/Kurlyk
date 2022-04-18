//
//  DefaultThemeProvider.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import Foundation
import SwiftUI

public struct DefaultThemeProvider: ThemeProvider {
    
    /// Default values for colors
    public var colors: Theme.Colors
    
    /// Default values for button styles
    public var buttonStyles: Theme.ButtonStyles
    
    /// Default values for sizes
    public var sizes: Theme.Sizes
    
    /// Default values for fonts. The system font is used.
    public var fonts: Theme.Fonts
    
    /// Sets the default values to the theme provider.
    public init() {
        colors = Self.defaultColors()
        sizes = Self.defaultSizes()
        buttonStyles = Self.defaultButtonStyles(colors: colors, sizes: sizes)
        fonts = Self.defaultFonts()
    }
}


// MARK: - Private initialization
private extension DefaultThemeProvider {
    
    static func defaultColors() -> Theme.Colors {
        .init(
            primary: .init(rgb: 0xfcd052),
            text: .init(
                primary: .init(rgb: 0x212121),
                secondary: .init(rgb: 0xffffff),
                placeholder: .init(rgb: 0x7f7f7f)
            ),
            navigation: .init(rgb: 0xf1f1f1),
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
                backgroundColor: colors.primary
            ),
            secondary: .init(
                foregroundColor: colors.text.secondary,
                borderColor: colors.primary,
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
            xl: 36,
            xxl: 48
        )
    }
    
    static func defaultFonts() -> Theme.Fonts {
        .init(
            defaultFont: { style, weight in
                .system(style).weight(weight)
            }
        )
    }
}
