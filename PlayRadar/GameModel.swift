//
//  GameModel.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation

public struct GameModel {
    public init(
        id: String,
        cover: URL? = nil,
        title: String,
        publisher: String,
        release: Date,
        rating: Double
    ) {
        self.id = id
        self.cover = cover
        self.title = title
        self.release = release
        self.rating = rating
        self.publisher = publisher
    }
    
    public let id: String
    public let cover: URL?
    public let title: String
    public let publisher: String
    public let release: Date
    public let rating: Double
}
