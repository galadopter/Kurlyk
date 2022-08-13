//
//  MoviesAPI.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation
import NetworkKit

public enum MoviesAPI {
    case popular(page: Int)
    case details(id: String)
}

// MARK: - RequestType
extension MoviesAPI: RequestType {
    
    public var baseURL: URL {
        Credentials.current.baseURL
    }
    
    public var path: String {
        switch self {
        case .popular(let page):
            return "/movie/popular?language=en-US&page=\(page)&api_key=\(Credentials.current.apiKey)"
        case .details(let id):
            return "/movie/\(id)?language=en-US&api_key=\(Credentials.current.apiKey)"
        }
    }
    
    public var method: RequestMethod {
        .get
    }
    
    public var headers: [String : String]? {
        [:]
    }
}
