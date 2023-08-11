//
//  GameListTests.swift
//  PlayRadariOSUITests
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import XCTest

final class GameListTests: XCTestCase {

    func testCheckShowListGames() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["uitest", "GameList"]
        
        let tablesQuery = app.tables
        XCTAssertTrue(tablesQuery.staticTexts["Game 1"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["Game 2"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["Game 3"].exists)
    }
    
    func testOnTapNavigateToDetail() throws {
        let app = XCUIApplication()
        app.launchArguments = ["uitest", "GameList","enableNavigation"]
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Game 1"].tap()
        
        let detailNavigationBar = app.navigationBars["Detail"]
        detailNavigationBar.staticTexts["Detail"].tap()
        detailNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["publisher 1"].tap()
        elementsQuery.staticTexts["Game 1"].tap()
        
        let releasedDate19700101StaticText = elementsQuery.staticTexts["Released date 1970-01-01"]
        releasedDate19700101StaticText.tap()
        
        let staticText = elementsQuery.staticTexts["1 Played"]
        staticText.tap()
        elementsQuery.staticTexts["description 1"].tap()
        
        let gamesForYouButton = detailNavigationBar.buttons["Games For You"]
        gamesForYouButton.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Game 2"]/*[[".cells.staticTexts[\"Game 2\"]",".staticTexts[\"Game 2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.staticTexts["publisher 2"].tap()
        elementsQuery.staticTexts["Game 2"].tap()
        releasedDate19700101StaticText.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"publisher 2").children(matching: .other).element.tap()
        elementsQuery.staticTexts["description 2"].tap()
        gamesForYouButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Game 3"]/*[[".cells.staticTexts[\"Game 3\"]",".staticTexts[\"Game 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.staticTexts["publisher 3"].tap()
        elementsQuery.staticTexts["Game 3"].tap()
        releasedDate19700101StaticText.tap()
        staticText.tap()
        elementsQuery.staticTexts["description 3"].tap()
        gamesForYouButton.tap()
                
    }
    
}
