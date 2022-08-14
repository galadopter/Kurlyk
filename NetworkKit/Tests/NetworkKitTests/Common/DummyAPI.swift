//
//  DummyAPI.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

@testable import NetworkKit

enum DummyAPI {
    case dummy
}

extension DummyAPI: RequestType {
    
    var baseURL: URL {
        URL(string: "www.test.com")!
    }
    
    var path: String {
        "/dummy"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var stubName: String? {
        nil
    }
    
    var headers: [String : String]? {
        [:]
    }
}
