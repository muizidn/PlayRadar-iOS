//
//  GameDetailInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation

public protocol GameDetailInteractor {
    func getGameDetail(id: String) async -> Result<GameDetailModel, Error>
}

public protocol FavoriteGameInteractor {
    func setFavorite(id: String,favorite: Bool) async
    func getFavorite(id: String) async -> Bool
}

