//
//  File.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import Foundation

public protocol ThemeProvider {
    /// Collection of colors in theme
    var colors: Theme.Colors { get set }
    
    /// Collection of button styles in theme
    var buttonStyles: Theme.ButtonStyles { get set }
    
    /// Collection of sizes in theme
    var sizes: Theme.Sizes { get set }
    
    /// Collection of fonts in theme
    var fonts: Theme.Fonts { get set }
}
