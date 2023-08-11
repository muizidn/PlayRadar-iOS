//
//  GameDetailModel.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation

public struct GameDetailModel {
    public init(game: GameModel, publisher: String, playCount: Int,gameDescription: String) {
        self.game = game
        self.publisher = publisher
        self.playCount = playCount
        self.gameDescription = gameDescription
    }
    
    public let game: GameModel
    public let publisher: String
    public let playCount: Int
    public let gameDescription: String
}

extension GameDetailModel: Equatable {}
