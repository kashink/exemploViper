//
//  HomeFeedEntity.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 05/09/21.
//

import UIKit
import Foundation

public struct HomeFeedEntity: Equatable, Decodable {
    public let tabList: [String]
    public var diskList: [HomeFeedDiskEntity]
    
    public init(tabList: [String], diskList: [HomeFeedDiskEntity]) {
        self.tabList = tabList
        self.diskList = diskList
    }
}

public struct HomeFeedDiskEntity: Equatable, Decodable {
    public let name: String
    public let imageUrl: String
    public var downloadedImage: UIImage?
    
    public init(name: String, imageUrl: String, downloadedImage: UIImage?) {
        self.name = name
        self.imageUrl = imageUrl
        self.downloadedImage = downloadedImage
    }
    
    enum CodingKeys: String, CodingKey {
        case name, imageUrl
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.downloadedImage = nil
    }
}
