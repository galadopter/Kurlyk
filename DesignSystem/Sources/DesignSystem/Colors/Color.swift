//
//  Color.swift
//  
//
//  Created by Yan Schneider on 1.02.22.
//

import UIKit
import SwiftUI

public struct Color {
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
    
    public var hex: String {
        let rgb =
            Int(red * 255) << 16
            | Int(green * 255) << 8
            | Int(blue * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(rgb: UInt, alpha: Float = 1) {
        self.init(
            red: Float((rgb & 0xFF0000) >> 16) / 255.0,
            green: Float((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Float(rgb & 0x0000FF) / 255.0,
            alpha: Float(alpha)
        )
    }
}

// MARK: UIKit
public extension Color {
    
    var uiColor: UIColor {
        .init(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
    
    init(uikit color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Float(red), green: Float(green), blue: Float(blue), alpha: Float(alpha))
    }
}

// MARK: - SwiftUI
public extension Color {
    
    var swiftUIColor: SwiftUI.Color {
        .init(uiColor: uiColor)
    }
    
    init(swiftui color: SwiftUI.Color) {
        self.init(uikit: UIColor(color))
    }
}
