//
//  NamedField.swift
//  Kurlyk
//
//  Created by Yan Schneider on 23.11.21.
//

import SwiftUI

public struct NamedField: View {
    
    let title: String
    let prompt: String
    @Binding var text: String
    
    public init(title: String, prompt: String, text: Binding<String>) {
        self.title = title
        self.prompt = prompt
        self._text = text
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.title)
                Spacer()
            }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            
            TextField(prompt, text: $text)
                .frame(height: 40)
                .padding(.horizontal, 16)
        }
    }
}

struct NamedField_Previews: PreviewProvider {
    static var previews: some View {
        NamedField(title: "Name", prompt: "Enter name", text: .constant(""))
    }
}
