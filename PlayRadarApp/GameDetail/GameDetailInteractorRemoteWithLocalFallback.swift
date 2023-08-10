//
//  GameDetailRemoteWithLocalFallbackInteractor.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

final class GameDetailRemoteWithLocalFallbackInteractor: GameDetailInteractor {
    let remote: GameDetailInteractor
    let local: LocalGameDetailInteractor
    
    init(remote: GameDetailInteractor, local: LocalGameDetailInteractor) {
        self.remote = remote
        self.local = local
    }
    
    func getGameDetail(id: String) async -> Result<String, Error> {
        let result = await remote.getGameDetail(id: id)
        switch result {
        case .success(let detail):
            _ = await local.saveGameDetail(id: id, contentDescription: detail)
            return result
        case .failure:
            let localResult = await local.getGameDetail(id: id)
            switch  localResult {
            case .success:
                return localResult
            case .failure:
                return result
            }
        }
        
    }
}
