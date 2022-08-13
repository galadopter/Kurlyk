//
//  File.swift
//  
//
//  Created by Yan Schneider on 12/08/2022.
//

import Foundation

public struct FavoriteMoviesStoreFabric {
    
    /// FavoriteMovies store types.
    public enum Store {
        /// Store that handles everything in memory. The scope determines how long should the memory live.
        case memory(scope: MemoryStoreScope)
        
        /// Scopes of Memory Store
        public enum MemoryStoreScope {
            /// Short term scope lives only when the coresponding store lives, so the values are tied to the particular instance of the store.
            case shortTerm
            
            /// With this scope the store will live as long as the app will.
            case appLifecycle
        }
    }
    
    /// Providing the requested store.
    ///
    /// - Parameter store: Specific store to be provided. Default to `memory`.
    ///
    /// - Returns: Instance of `FavoriteMoviesStore`.
    public static func provide(store: Store = .memory(scope: .shortTerm)) -> FavoriteMoviesStore {
        switch store {
        case .memory(.shortTerm):
            return InMemoryFavoriteMoviesStore()
        case .memory(scope: .appLifecycle):
            return InMemoryFavoriteMoviesStore.shared
        }
    }
}
