//
//  Network.swift
//  Infrastructure
//
//  Created by Yan Schneider on 27/12/2021.
//

import Foundation
import Domain

/// Hanldes network calls, based on the given `RequestType`
///
/// Uses `URLSession` under-the-hood.
open class Network<API: RequestType> {
    
    private let session: URLSession
    
    public enum NetworkError: Error, Equatable {
        case incorrectRequest
        case unauthorized
        case badRequest
        case serverError
        case noConnection
        case decodingFailed
    }
    
    /// Initialiser for Network class.
    ///
    /// - Parameter session: Instance of `URLSession`. Default: shared instance.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Makes a request for given `API`.
    ///
    /// - Parameter api: Particular `RequestType` which is used to make a request.
    /// - Parameter decoder: Instance of `JSONDecoder` which is used to parse data from response. Default: standard decoder.
    ///
    /// - Returns: Data of a given type.
    open func fetch<T: Decodable>(_ api: API, decoder: JSONDecoder = .init()) async throws -> T {
        guard let request = RequestBuilder(api).build() else {
            throw NetworkError.incorrectRequest
        }
        return try await makeRequest(request, decoder: decoder)
    }
}

// MARK: - Request task
private extension Network {
    
    func makeRequest<T: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder
    ) async throws -> T {
        let (data, response) = try await transformError({
            try await session.data(for: request)
        }, to: NetworkError.noConnection)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noConnection
        }
        
        switch response.statusCode {
        case 200...299:
            return try transformError({
                try decoder.decode(T.self, from: data)
            }, to: NetworkError.decodingFailed)
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            throw NetworkError.badRequest
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.serverError
        }
    }
}
