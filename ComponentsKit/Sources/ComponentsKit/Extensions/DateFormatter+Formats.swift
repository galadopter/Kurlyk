//
//  File.swift
//  
//
//  Created by Yan Schneider on 29/04/2022.
//

import Foundation

public extension DateFormatter {
    
    /// Medium format style.
    ///
    /// Date should appear in the following way: April 26, 2007.
    static var medium: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }
}
