//
//  GameDetailModel.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation

public struct GameDetailModel {
    public init(game: GameModel, publisher: String, gameDescription: String) {
        self.game = game
        self.publisher = publisher
        self.gameDescription = gameDescription
    }
    
    public let game: GameModel
    public let publisher: String
    public let gameDescription: String
}
