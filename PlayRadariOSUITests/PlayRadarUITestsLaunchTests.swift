//
//  PlayRadarUITestsLaunchTests.swift
//  PlayRadariOSUITests
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import XCTest

final class PlayRadarUITestsGameListTests: XCTestCase {

    func testCheckShowListGames() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["uitest"]
            
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Game 1"]/*[[".cells.staticTexts[\"Game 1\"]",".staticTexts[\"Game 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Game 2"]/*[[".cells.staticTexts[\"Game 2\"]",".staticTexts[\"Game 2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Game 3"]/*[[".cells.staticTexts[\"Game 3\"]",".staticTexts[\"Game 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
}
