//
//  CoreDataLocalGameDetailInteractorTests.swift
//  PlayRadarLocalTests
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import XCTest
@testable import PlayRadarLocal
import PlayRadar

class CoreDataLocalGameDetailInteractorTests: XCTestCase {

    var spyClient: SpyDatabaseClient!
    var interactor: CoreDataLocalGameDetailInteractor!

    override func setUp() {
        super.setUp()
        spyClient = SpyDatabaseClient(spied: CoreDataDatabase.shared)
        interactor = CoreDataLocalGameDetailInteractor(databaseClient: spyClient)
    }

    override func tearDown() {
        spyClient = nil
        interactor = nil
        super.tearDown()
    }

    func testGetGameDetail() async throws {
        try await spyClient.clearDatabase()
        
        let mockGameId = "1"
        let mockGameTitle = "Mock Game"
        let mockGameReleaseDate = Date()
        let mockGameRating: Double = 4.5
        let mockGamePublisher = "Mock Publisher"
        let mockPlayCount = 100
        let mockGameDescription = "This is a mock game description."

        try await spyClient.seedDatabase(CDGame.self, ids: [mockGameId])
        try await spyClient.update(CDGame.self, where: ["id":mockGameId]) { e in
            e.id = mockGameId
            e.title = mockGameTitle
            e.releaseDate = mockGameReleaseDate
            e.rating = mockGameRating
            e.publisher = mockGamePublisher
            e.playCount = Int16(mockPlayCount)
            e.gameDescription = mockGameDescription
        }

        let result = await interactor.getGameDetail(id: mockGameId)

        switch result {
        case .success(let gameDetail):
            XCTAssertEqual(gameDetail.game.id, mockGameId)
            XCTAssertEqual(gameDetail.game.title, mockGameTitle)
            XCTAssertEqual(gameDetail.game.release, mockGameReleaseDate)
            XCTAssertEqual(gameDetail.game.rating, mockGameRating)
            XCTAssertEqual(gameDetail.publisher, mockGamePublisher)
            XCTAssertEqual(gameDetail.playCount, mockPlayCount)
            XCTAssertEqual(gameDetail.gameDescription, mockGameDescription)
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testSaveGameDetail() async throws {
        try await spyClient.clearDatabase()
        
        let mockGameId = "1"
        let mockGameDetail = GameDetailModel(
            game: GameModel(
                id: mockGameId,
                title: "Foo",
                release: Date(timeIntervalSince1970: 0),
                rating: 12),
            publisher: "Bar",
            playCount: 2,
            gameDescription: "Qux"
        )

        try await interactor.saveGameDetail(id: mockGameId, detail: mockGameDetail).get()

        let savedGame = try await spyClient.get(CDGame.self, where: ["id": mockGameId])
        XCTAssertNotNil(savedGame)
        XCTAssertEqual(savedGame?.id, mockGameId)
        XCTAssertEqual(savedGame?.title, "Foo")
        XCTAssertEqual(savedGame?.publisher, "Bar")
    }

}
