//
//  LocalGameDetailInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation

public protocol LocalGameDetailInteractor: GameDetailInteractor {
    func saveGameDetail(id: String, detail: GameDetailModel) async -> Result<Void, Error>
}
