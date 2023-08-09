//
//  GameListAPIInteractorTests.swift
//  PlayRadarTests
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import XCTest
import Combine
@testable import PlayRadar

class GameListInteractorTests: XCTestCase {
    
    var interactor: GameListInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = GameListAPIInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        super.tearDown()
    }
    
    func testLoadGames() async {
        let result = await interactor.loadGames(page: 1)
        
        switch result {
        case .success(let pagination):
            XCTAssertEqual(pagination.data, [], "Games should not be empty")
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

extension GameModel: Equatable {
    public static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.cover == rhs.cover &&
        lhs.title == rhs.title &&
        lhs.release == rhs.release &&
        lhs.rating == rhs.rating
    }
}
