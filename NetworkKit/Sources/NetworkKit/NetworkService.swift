//
//  NetworkService.swift
//  Infrastructure
//
//  Created by Yan Schneider on 27/12/2021.
//

import Foundation

/// Base class for API services. It meant to be used as a superclass for all API services.
///
/// Here's an example of  how API could be divided into services:
///  - `posts/ --> PostsAPI + PostsService`
///  - `users/ --> UsersAPI + UsersService`
open class NetworkService<API: RequestType> {
    
    public let network: Network<API>
    
    public init(network: Network<API> = Network()) {
        self.network = network
    }
}
