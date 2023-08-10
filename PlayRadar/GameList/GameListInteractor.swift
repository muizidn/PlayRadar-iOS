//
//  GameListInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import Combine

public protocol GameListInteractor {
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error>
    func searchGames(query: String) async -> Result<[GameModel], Error>
}
