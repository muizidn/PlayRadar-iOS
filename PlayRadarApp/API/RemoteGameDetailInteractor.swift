//
//  RemoteGameDetailInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

public final class RemoteGameDetailInteractor: GameDetailInteractor {
    public init() {}
    public func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
        return .success(GameDetailModel(game: GameModel(id: "1", title: "Foo", release: Date(), rating: 1), publisher: "MGS", gameDescription: "bar"))
    }
}
