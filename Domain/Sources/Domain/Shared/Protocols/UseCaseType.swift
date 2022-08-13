//
//  UseCaseType.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public protocol UseCaseType {
    associatedtype Input
    associatedtype Output
    func execute(input: Input) -> Output
}

public protocol ThrowableUseCaseType {
    associatedtype Input
    associatedtype Output
    func execute(input: Input) throws -> Output
}

public protocol AsyncUseCaseType {
    associatedtype Input
    associatedtype Output
    func execute(input: Input) async -> Output
}

public protocol AsyncThrowingUseCaseType {
    associatedtype Input
    associatedtype Output
    func execute(input: Input) async throws -> Output
}

public protocol AsyncThrowingNoInputUseCaseType {
    associatedtype Output
    func execute() async throws -> Output
}
