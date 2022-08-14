//
//  StubbedURLProtocol.swift
//  InfrastructureTests
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

/// This is a stubbed URL protocol for Infrastructure unit tests only.
/// It's needed to verify that `Network` correctly handles all types of requests.
class StubbedURLProtocol: URLProtocol {
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    static func reset() {
        data = nil
        response = nil
        error = nil
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
        Self.data = data
        Self.response = response
        Self.error = error
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let data = Self.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = Self.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
