//
//  ErrorTransformer.swift
//  
//
//  Created by Yan Schneider on 28/04/2022.
//

import Foundation

public func transformError<Failure: Error>(_ block: () throws -> Void, to newError: Failure) throws {
    do {
        try block()
    } catch {
        throw newError
    }
}

public func transformError<Failure: Error>(_ block: () async throws -> Void, to newError: Failure) async throws {
    do {
        try await block()
    } catch {
        throw newError
    }
}

public func transformError<Value, Failure: Error>(_ block: () throws -> Value, to newError: Failure) throws -> Value {
    do {
        return try block()
    } catch {
        throw newError
    }
}

public func transformError<Value, Failure: Error>(_ block: () async throws -> Value, to newError: Failure) async throws -> Value {
    do {
        return try await block()
    } catch {
        throw newError
    }
}
