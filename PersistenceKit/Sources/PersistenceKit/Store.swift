//
//  Store.swift
//  
//
//  Created by Yan Schneider on 04/11/2022.
//

import Foundation

/// Abstract store with cache functionality.
/// It is possible to provide any kind of storage to both `storage` and `cache`.
open class Store<T: Codable & Identifiable> {
    
    private let storage: any Storage<T, T.ID>
    private let cache: any Storage<T, T.ID>
    
    public init(storage: any Storage<T, T.ID>, cache: any Storage<T, T.ID>) {
        self.storage = storage
        self.cache = cache
        
        initializeCache()
    }
}

// MARK: - Get
extension Store {
    
    public func get() async throws -> [T] {
        let cachedValues = try await cache.get()
        
        if cachedValues.isEmpty {
            let storedValues = try await storage.get()
            
            for value in storedValues {
                try await cache.save(value)
            }
            
            return storedValues
        } else {
            return cachedValues
        }
    }
}

// MARK: - Save
extension Store {
    
    public func save(value: T) async throws {
        try await cache.save(value)
        
        Task {
            do {
                try await storage.save(value)
            } catch {
                try await cache.remove(value.id)
            }
        }
    }
}

// MARK: - Delete
extension Store {
    
    public func delete(id: T.ID) async throws {
        let removedValue = try await cache.remove(id)
        
        Task {
            do {
                try await storage.remove(id)
            } catch {
                try await cache.save(removedValue)
            }
        }
    }
}

// MARK: - Contains
extension Store {
    
    public func contains(id: T.ID) async throws -> Bool {
        try await cache.contains(id)
    }
}

// MARK: - Cache
private extension Store {
    
    func initializeCache() {
        Task {
            let storedValues = try await storage.get()
            
            for value in storedValues {
                try await cache.save(value)
            }
        }
    }
}
