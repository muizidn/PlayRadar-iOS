//
//  GameDetailAPIInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation

public final class GameDetailAPIInteractor: GameDetailInteractor {
    public init() {}
    public func getGameDetail(id: String) async -> Result<String, Error> {
        return .success("")
    }
}
