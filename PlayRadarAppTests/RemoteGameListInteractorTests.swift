//
//  RemoteGameListInteractorTests.swift
//  PlayRadarTests
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import XCTest
import Combine
@testable import PlayRadarApp
import PlayRadar

class RemoteGameGameListInteractorTests: XCTestCase {
    
    var interactor: GameListInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = RemoteGameListInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        super.tearDown()
    }
    
    func testLoadGames() async {
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
        let result = await interactor.searchGames(query: "BioShock")
        
        switch result {
        case .success(let games):
            XCTAssertEqual(games, [], "Search results should not be empty")
        case .failure(let error):
            XCTFail("Failed with error: \(error)")
        }
    }
}
