//
//  RequestBuilder.swift
//  
//
//  Created by Yan Schneider on 28/04/2022.
//

import Foundation

struct RequestBuilder<API: RequestType> {
    let api: API
    
    init(_ api: API) {
        self.api = api
    }
}

// MARK: - Builder
extension RequestBuilder {
    
    func build() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.value
        request.allHTTPHeaderFields = api.headers
        
        return request
    }
}

// MARK: - Helpers
private extension RequestBuilder {
    
    func makeURL() -> URL? {
        let absoluteString = api.baseURL.appendingPathComponent(api.path).absoluteString
        let removedPercentageEncoding = absoluteString.removingPercentEncoding
        let replacedSpaces = removedPercentageEncoding?.replacingOccurrences(of: " ", with: "+")
        
        return replacedSpaces.flatMap { URL(string: $0) }
    }
}
