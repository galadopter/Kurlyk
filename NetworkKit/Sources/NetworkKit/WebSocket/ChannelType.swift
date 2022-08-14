//
//  ChannelType.swift
//  Infrastructure
//
//  Created by Yan Schneider on 19/05/2022.
//

import Foundation

public protocol ChannelType: Hashable {
    var name: String { get }
}
