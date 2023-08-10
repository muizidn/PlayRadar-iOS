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
    public func getGameDetail(id: String) async -> Result<String, Error> {
        return .success("Some world")
    }
}
