//
//  GameListRemoteWithLocalFallbackInteractor.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

final class GameListRemoteWithLocalFallbackInteractor: GameListInteractor {
    let remote: GameListInteractor
    let local: LocalGameListInteractor
    
    init(remote: GameListInteractor, local: LocalGameListInteractor) {
        self.remote = remote
        self.local = local
    }
    
    
    func loadGames(page: Int) async -> Result<PlayRadar.Pagination<PlayRadar.GameModel>, Error> {
        let result = await remote.loadGames(page: page)
        switch result {
        case .success(let games):
            print("Games", games.data[3])
            _ = await local.saveGames(games.data)
            return result
        case .failure:
            let localResult = await local.loadGames(page: page)
            switch  localResult {
            case .success:
                return localResult
            case .failure:
                return result
            }
        }
    }
    
    func searchGames(query: String) async -> Result<[PlayRadar.GameModel], Error> {
        let result = await remote.searchGames(query: query)
        switch result {
        case .success(let games):
            _ = await local.saveGames(games)
            return result
        case .failure:
            let localResult = await local.searchGames(query: query)
            switch  localResult {
            case .success:
                return localResult
            case .failure:
                return result
            }
        }
    }
}
