//
//  File.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import Foundation

extension Theme {
    
    /// Colors in the particular theme
    public struct Colors {
        /// Primary color.
        public var primary: Color
        
        /// Text colors
        public var text: Text
        
        /// Background color
        public var background: Color
    }
}

extension Theme.Colors {
    
    /// Text colors
    public struct Text {
        /// Primary text color
        public var primary: Color
        
        /// Secondary text color
        public var secondary: Color
    }
}
