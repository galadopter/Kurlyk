//
//  DI.swift
//  Domain
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation

public enum DI {

    public typealias Resolver<T> = () -> T
    private static var dependencies: [TypeHash: Resolver<Any>] = [:]
    private static var mocks: [TypeHash: Resolver<Any>] = [:]

    /// Bind a Type to a single instance, making this resolve to a singleton
    public static func bind<T>(_ type: T.Type, _ instance: T) -> Resolver<T> {
        bind(type) { instance }
    }

    /// Bind a Type to a closure, which will be run everytime this is accessed.
    /// Useful for non singleton dependencies
    public static func bind<T>(_ type: T.Type, _ instatiator: @escaping Resolver<T>) -> Resolver<T> {
        dependencies[TypeHash(type)] = instatiator
        return getInstance
    }

    /// Mock a Type to a single instance, making this resolve to a singleton
    public static func mock<T>(_ type: T.Type, _ instance: T) {
        mock(type) { instance }
    }

    /// Mock a Type to a closure, which will be run everytime this is accessed.
    /// Useful for non singleton dependencies
    public static func mock<T>(_ type: T.Type, _ instatiator: @escaping Resolver<T>) {
        mocks[TypeHash(type)] = instatiator
    }

    /// Remove all the mocks that were added with mock()
    public static func unmock() {
        mocks = [:]
    }

    private static func getInstance<T>() -> T {
        let typeHash = TypeHash(T.self)

        let instatiator: Resolver<Any>
        if isTestExecution, let dependencyInstatiator = mocks[typeHash] {
            instatiator = dependencyInstatiator
        } else if let dependencyInstatiator = dependencies[typeHash] {
            instatiator = dependencyInstatiator
        } else {
            fatalError("Impossible DI error: instatiator not found")
        }

        guard let value = instatiator() as? T else {
            fatalError("Impossible DI error: value not the right type")
        }
        return value
    }

    private static var isTestExecution: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}

private struct TypeHash: Hashable {

    let name: String

    init(_ type: Any.Type) {
        name = String(describing: type)
    }
}
