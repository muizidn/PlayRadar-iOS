//
//  GameCellTests.swift
//  PlayRadariOSTests
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import XCTest
@testable import PlayRadariOS
import PlayRadar

class GameCellTests: XCTestCase {
    
    var sut: GameCell!
    
    override func setUp() {
        super.setUp()
        sut = GameCell(style: .default, reuseIdentifier: "GameCell")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testConfigureTitleLabel() {
        let game = GameViewModel(
            id: "1",
            coverImage: nil,
            title: "Title World From Best Movie",
            releaseDate: createDate(0, 0, 0),
            rating: 0.0)
        
        sut.configure(with: game)
        
        XCTAssertEqual(sut.titleLabel.text, "Title World From Best Movie")
    }
    
    func testConfigureReleaseLabel() {
        let game = GameViewModel(
            id: "1",
            coverImage: nil,
            title: "",
            releaseDate: createDate(2025, 12, 08),
            rating: 4.5)
        
        sut.configure(with: game)
        
        XCTAssertEqual(sut.releaseDateLabel.text, "Released date 2025-12-08")
    }
    
    func testConfigureRatingLabel() {
        let game = GameViewModel(
            id: "1",
            coverImage: nil,
            title: "",
            releaseDate: createDate(0, 0, 0),
            rating: 4.5)
        
        sut.configure(with: game)
        
        XCTAssertEqual(sut.ratingLabel.text, "4.5")
    }
    
    func testConfigureWithRatingLabelEven() {
        let game = GameViewModel(
            id: "1",
            coverImage: nil,
            title: "",
            releaseDate: createDate(0, 0, 0),
            rating: 3.0)
        
        sut.configure(with: game)
        
        XCTAssertEqual(sut.ratingLabel.text, "3")
    }
    
    private func createDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.timeZone = TimeZone(identifier: "UTC")

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
}
