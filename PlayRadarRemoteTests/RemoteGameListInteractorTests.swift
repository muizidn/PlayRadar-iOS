//
//  RemoteGameListInteractorTests.swift
//  PlayRadarTests
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import XCTest
import Combine
@testable import PlayRadarRemote
import PlayRadar

class RemoteGameGameListInteractorTests: XCTestCase {
    
    var interactor: GameListInteractor!
    var stubClient: StubHttpClient!
    
    override func setUp() {
        super.setUp()
        stubClient = StubHttpClient()
        interactor = RemoteGameListInteractor(
            httpClient: stubClient
        )
    }
    
    override func tearDown() {
        interactor = nil
        stubClient = nil
        super.tearDown()
    }
    
    func testLoadGames() async {
        stubClient.requestResponse = (
            """
            {
                "next": "http://api/next",
                "results": [
                    {
                        "id": 1,
                        "background_image": "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg",
                        "name": "BioShock 2 Remastered Japan Version",
                        "released": "1970-01-01",
                        "rating": 4.2
                    },
                    {
                        "id": 2,
                        "background_image": "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg",
                        "name": "BioShock 2 Remastered Japan Version",
                        "released": "1970-01-01",
                        "rating": 4.2
                    },
                    {
                        "id": 3,
                        "background_image": "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg",
                        "name": "BioShock 2 Remastered Japan Version",
                        "released": "1970-01-01",
                        "rating": 4.2
                    }
                ]
            }
            """.data(using: .utf8)!,
            .success
        )
        
        let result = await interactor.loadGames(page: 1)
        
        switch result {
        case .success(let pagination):
            XCTAssertEqual(pagination.data, [
                GameModel(
                    id: "1",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                GameModel(
                    id: "2",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                GameModel(
                    id: "3",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
            ], "Games should not be empty")
        case .failure(let error):
            XCTFail("Failed with error: \(error)")
        }
    }
    
    func testSearchGames() async {
        stubClient.requestResponse = (
            """
            {
                "next": "http://api/next",
                "results": [
                    {
                        "id": 1,
                        "background_image": "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg",
                        "name": "BioShock 2 Remastered Japan Version",
                        "released": "1970-01-01",
                        "rating": 4.2
                    },
                    {
                        "id": 2,
                        "background_image": "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg",
                        "name": "BioShock 2 Remastered Japan Version",
                        "released": "1970-01-01",
                        "rating": 4.2
                    },
                    {
                        "id": 3,
                        "background_image": "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg",
                        "name": "BioShock 2 Remastered Japan Version",
                        "released": "1970-01-01",
                        "rating": 4.2
                    }
                ]
            }
            """.data(using: .utf8)!,
            .success
        )
        
        let result = await interactor.searchGames(query: "BioShock")
        
        switch result {
        case .success(let games):
            XCTAssertEqual(games, [
                GameModel(
                    id: "1",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                GameModel(
                    id: "2",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                GameModel(
                    id: "3",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
            ], "Search results should not be empty")
        case .failure(let error):
            XCTFail("Failed with error: \(error)")
        }
    }
}
