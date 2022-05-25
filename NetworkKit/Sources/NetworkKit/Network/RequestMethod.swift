//
//  RequestMethod.swift
//  
//
//  Created by Yan Schneider on 28/04/2022.
//

import Foundation

public enum RequestMethod: String {
    case get, post, put, delete, patch
    
    public var value: String {
        rawValue.uppercased()
    }
}
