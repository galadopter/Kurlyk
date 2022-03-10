//
//  SwiftUI+Color.swift
//  
//
//  Created by Yan Schneider on 1.02.22.
//

import SwiftUI

public extension View {
    
    func foregroundColor(_ color: Color) -> some View {
        foregroundColor(color.swiftUIColor)
    }
    
    func background(_ color: Color) -> some View {
        background(color.swiftUIColor)
    }
}

extension SwiftUI.Color {
    
    static func design(_ color: Color) -> SwiftUI.Color {
        color.swiftUIColor
    }
}
