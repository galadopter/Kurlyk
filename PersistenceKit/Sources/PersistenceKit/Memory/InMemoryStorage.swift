//
//  InMemoryStorage.swift
//  
//
//  Created by Yan Schneider on 04/11/2022.
//

import Foundation

public actor InMemoryStorage<T: Codable & Identifiable>: Storage {
    
    public typealias Model = T
    public typealias ModelID = T.ID
    
    private var storage: [T.ID: T]
    
    public enum InMemoryStorageError: Error {
        case removingNonExistentValue
    }
    
    public init(initialValues: [T] = []) {
        var valueMap = [T.ID: T]()
        
        for value in initialValues {
            valueMap[value.id] = value
        }
        
        storage = valueMap
    }
    
    public func get() async throws -> [T] {
        storage.map { $0.value }
    }
    
    public func save(_ model: T) async throws {
        storage[model.id] = model
    }
    
    public func remove(_ modelID: T.ID) async throws -> T {
        if let removingValue = storage[modelID] {
            storage[modelID] = nil
            return removingValue
        } else {
            throw InMemoryStorageError.removingNonExistentValue
        }
    }
    
    public func contains(_ modelID: T.ID) async throws -> Bool {
        storage[modelID] != nil
    }
}
