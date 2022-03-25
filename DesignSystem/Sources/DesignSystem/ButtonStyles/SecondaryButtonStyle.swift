//
//  SecondaryButtonStyle.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import SwiftUI

/// Button style for secondary button type.
public struct SecondaryButtonStyle: ButtonStyle {
    
    public let foregroundColor: Color
    
    public let borderColor: Color
    
    public let borderWidth: CGFloat
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public init(
        foregroundColor: Color,
        borderColor: Color,
        borderWidth: CGFloat
    ) {
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .foregroundColor(configuration.pressed(color: foregroundColor))
            Spacer()
        }
            .padding()
            .overlay(
                Capsule(style: .continuous)
                    .stroke(configuration.pressed(color: borderColor).swiftUIColor, style: .init(lineWidth: borderWidth))
            )
            .opacity(isEnabled ? 1 : 0.5)
    }
}
