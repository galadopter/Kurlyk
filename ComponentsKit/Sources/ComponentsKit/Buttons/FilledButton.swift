//
//  FilledButton.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import SwiftUI
import DesignSystem

public struct FilledButton: View {
    let title: String
    var backgroundColor: DesignSystem.Color
    let action: () -> ()
    
    public init(
        title: String,
        backgroundColor: DesignSystem.Color = .primary,
        action: @escaping () -> ()
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .foregroundColor(.primaryText)
                Spacer()
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
        }.buttonStyle(.plain)
    }
}

struct FilledButton_Previews: PreviewProvider {
    static var previews: some View {
        FilledButton(title: "Create post", action: {})
    }
}
