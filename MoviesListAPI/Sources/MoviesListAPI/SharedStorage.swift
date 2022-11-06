//
//  File.swift
//  
//
//  Created by Yan Schneider on 05/11/2022.
//

import Foundation
import PersistenceKit

enum SharedStorage {
    static let favoriteMoviesCache = InMemoryStorage<FavoriteMovieFileRepresentation>()
}
