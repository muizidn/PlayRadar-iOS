//
//  GameDetailRemoteWithLocalFallbackInteractor.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation

public final class GameDetailRemoteWithLocalFallbackInteractor: GameDetailInteractor {
    let remote: GameDetailInteractor
    let local: LocalGameDetailInteractor
    
    public init(remote: GameDetailInteractor, local: LocalGameDetailInteractor) {
        self.remote = remote
        self.local = local
    }
    
    public func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
        let result = await remote.getGameDetail(id: id)
        switch result {
        case .success(let detail):
            _ = await local.saveGameDetail(id: id, detail: detail)
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
