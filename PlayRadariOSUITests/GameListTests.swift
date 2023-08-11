//
//  GameListTests.swift
//  PlayRadariOSUITests
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import XCTest

final class GameListTests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testCheckShowListGames() throws {
        app.launch(args: ["uitest", "GameList"])
        verifyGamesAreDisplayed(["Game 1", "Game 2", "Game 3"])
    }
    
    func testOnTapNavigateToDetail() throws {
        app.launch(args: ["uitest", "GameList", "enableNavigation"])
        
        tapOnGame("Game 1")
        verifyDetailScreen(1)
        tapBackButton()
        
        tapOnGame("Game 2")
        verifyDetailScreen(2)
        tapBackButton()

        tapOnGame("Game 3")
        verifyDetailScreen(3)
        tapBackButton()
    }
    
    // Utility functions
    
    func verifyGamesAreDisplayed(_ gameNames: [String]) {
        let tablesQuery = app.tables
        for gameName in gameNames {
            XCTAssertTrue(tablesQuery.staticTexts[gameName].exists)
        }
    }
    
    func tapOnGame(_ gameName: String) {
        XCTAssertTrue(app.tables.staticTexts[gameName].exists)
        app.tables.staticTexts[gameName].tap()
    }
    
    func verifyDetailScreen(_ id: Int) {
        XCTAssertTrue(app.navigationBars["Detail"].exists)
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        XCTAssertTrue(elementsQuery.staticTexts["Game \(id)"].exists)
        XCTAssertTrue(elementsQuery.staticTexts["publisher \(id)"].exists)
        
        let releasedDate19700101StaticText = elementsQuery.staticTexts["Released date 1970-01-01"]
        XCTAssertTrue(releasedDate19700101StaticText.exists)
        
        let staticText = elementsQuery.staticTexts["\(id) Played"]
        XCTAssertTrue(staticText.exists)
        
        XCTAssertTrue(elementsQuery.staticTexts["description \(id)"].exists)
    }
    
    func tapBackButton() {
        let detailNavBar = app.navigationBars["Detail"]
        let gamesForYouButton = detailNavBar.buttons["Games For You"]
        gamesForYouButton.tap()
    }
}
