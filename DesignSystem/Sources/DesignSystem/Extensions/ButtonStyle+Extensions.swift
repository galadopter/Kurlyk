//
//  ButtonStyle+Extensions.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import SwiftUI

extension ButtonStyle.Configuration {
    
    func pressed(color: Color) -> Color {
        isPressed ? color.adjusted(byPercentage: 30) : color
    }
}
