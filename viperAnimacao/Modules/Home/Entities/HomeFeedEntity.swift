//
//  HomeFeedEntity.swift
//  viperAnimacao
//
//  Created by fleury on 05/09/21.
//

import Foundation

public struct HomeFeedEntity: Equatable, Decodable {
    public let tabList: [String]
    public let diskList: [HomeFeedDiskEntity]
    
    public init(tabList: [String], diskList: [HomeFeedDiskEntity]) {
        self.tabList = tabList
        self.diskList = diskList
    }
}

public struct HomeFeedDiskEntity: Equatable, Decodable {
    public let name: String
    public let imageUrl: String
    
    public init(name: String, imageUrl: String) {
        self.name = name
        self.imageUrl = imageUrl
    }
}
