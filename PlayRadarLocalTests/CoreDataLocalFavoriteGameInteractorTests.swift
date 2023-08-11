//
//  PlayRadarLocalTests.swift
//  PlayRadarLocalTests
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import XCTest
@testable import PlayRadarLocal
import PlayRadar

class CoreDataLocalFavoriteGameInteractorTests: XCTestCase {

    var spyClient: SpyDatabaseClient!
    var interactor: CoreDataLocalFavoriteGameInteractor!

    override func setUp() {
        super.setUp()
        spyClient = SpyDatabaseClient(spied: CoreDataDatabase.shared)
        interactor = CoreDataLocalFavoriteGameInteractor(databaseClient: spyClient)
    }

    override func tearDown() {
        spyClient = nil
        interactor = nil
        super.tearDown()
    }

    func testSetFavorite() async throws {
        try await spyClient.prefillDatabase(CDGame.self,ids: ["1"])
        await interactor.setFavorite(id: "1", favorite: true)

        XCTAssertTrue(spyClient.saveCalled)
        try await spyClient.clearDatabase()
    }

    func testRemoveFavorite() async throws {
        try await spyClient.prefillDatabase(CDGame.self,ids: ["1"])
        try await spyClient.prefillDatabase(CDFavorite.self,ids: ["1"])
        await interactor.setFavorite(id: "1", favorite: false)

        XCTAssertTrue(spyClient.deleteCalled)
        try await spyClient.clearDatabase()
    }
    
    // implement other test case
}
