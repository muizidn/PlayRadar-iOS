//
//  LocalGameListInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation

public protocol LocalGameListInteractor: GameListInteractor {
    func saveGames(_ games: [GameModel]) async -> Result<Void, Error>
}
