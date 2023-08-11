//
//  FavoriteGameInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation

public protocol FavoriteGameInteractor {
    func setFavorite(id: String,favorite: Bool) async
    func getFavorite(id: String) async -> Bool
}
