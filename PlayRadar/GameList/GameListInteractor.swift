//
//  GameListInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import Combine

protocol GameListInteractor {
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error>
    func searchGames(query: String) async -> Result<[GameModel], Error>
}

final class GameListAPIInteractor: GameListInteractor {
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        return .success(.init(data: [
            ], page: page, count: 0))
    }
    
    func searchGames(query: String) async -> Result<[GameModel], Error> {
        return .success([])
    }
}