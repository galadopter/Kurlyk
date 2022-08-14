//
//  File.swift
//  
//
//  Created by Yan Schneider on 11/08/2022.
//

import Foundation
import Domain

public protocol FavoriteMoviesStore: GetFavoriteMoviesGateway, DeleteFavoriteMovieGateway,
                                     SaveFavoriteMovieGateway, CheckMovieIsFavoriteGateway {
    
}
