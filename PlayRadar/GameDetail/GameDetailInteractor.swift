//
//  GameDetailInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation

protocol GameDetailInteractor {
    func getGameDetail(id: String) async -> Result<String, Error>
}

