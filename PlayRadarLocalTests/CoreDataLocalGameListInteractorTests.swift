//
//  CoreDataLocalGameListInteractorTests.swift
//  PlayRadarLocalTests
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import XCTest
@testable import PlayRadarLocal
import PlayRadar

class CoreDataLocalGameListInteractorTests: XCTestCase {

    var spyClient: SpyDatabaseClient!
    var interactor: CoreDataLocalGameListInteractor!

    override func setUp() {
        super.setUp()
        spyClient = SpyDatabaseClient(spied: CoreDataDatabase.shared)
        interactor = CoreDataLocalGameListInteractor(databaseClient: spyClient)
    }

    override func tearDown() {
        spyClient = nil
        interactor = nil
        super.tearDown()
    }

    func testLoadGames() async throws {
        try await spyClient.clearDatabase()
        for id in ["1", "2"] {
            try await spyClient.seedDatabase(CDGame.self,ids: [id])
            let game = try await spyClient.get(CDGame.self, where: ["id": id])!
            try await spyClient.save(CDFavorite.self) { e in
                e.id = id
                e.game = game
            }
        }

        let result = await interactor.loadGames(page: 1)

        switch result {
        case .success(let pagination):
            XCTAssertEqual(pagination.data.count, 2)
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testSearchGames() async {
    }

}
