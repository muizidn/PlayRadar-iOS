//
//  LocalGameDetailInteractor.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

protocol LocalGameDetailInteracotr: GameDetailInteractor {
    func saveGameDetail(id: String, contentDescription: String) async -> Result<Void, Error>
}

final class CoreDataLocalGameDetailInteractor: LocalGameDetailInteracotr {
    func getGameDetail(id: String) async -> Result<String, Error> {
        do {
            let desc = try await CoreDataDatabase.shared.get(CDGame.self, where: ["id": id])?.gameDescription
            return .success(desc ?? "")
        } catch {
            return .failure(error)
        }
    }
    
    func saveGameDetail(id: String, contentDescription: String) async -> Result<Void, Error> {
        do {
            try await CoreDataDatabase.shared.save(CDGame.self, closure: { e in
                e.id = id
                e.gameDescription = contentDescription
            })
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
