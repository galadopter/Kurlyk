//
//  File.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import SwiftUI

/// Button style for primary button type.
public struct PrimaryButtonStyle: ButtonStyle {
    
    public let foregroundColor: Color
    
    public let backgroundColor: Color
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public init(
        foregroundColor: Color,
        backgroundColor: Color
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .foregroundColor(configuration.pressed(color: foregroundColor))
            Spacer()
        }
            .padding()
            .background(configuration.pressed(color: backgroundColor))
            .opacity(isEnabled ? 1 : 0.5)
            .clipShape(Capsule())
    }
}
