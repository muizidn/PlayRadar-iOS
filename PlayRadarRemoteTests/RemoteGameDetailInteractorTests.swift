//
//  RemoteGameDetailInteractorTests.swift
//  PlayRadarRemoteTests
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
import XCTest
import Combine
@testable import PlayRadarRemote
import PlayRadar

class RemoteGameDetailInteractorTests: XCTestCase {
    
    var interactor: GameDetailInteractor!
    var stubClient: StubHttpClient!
    
    override func setUp() {
        super.setUp()
        stubClient = StubHttpClient()
        interactor = RemoteGameDetailInteractor(
            httpClient: stubClient
        )
    }
    
    override func tearDown() {
        interactor = nil
        stubClient = nil
        super.tearDown()
    }
    
    func testGetGameDetail() async {
        stubClient.requestResponse = (
            """
            {
                "id": 1,
                "name": "BioShock 2 Remastered Japan Version",
                "background_image": "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg",
                "released_at": "1970-01-01",
                "rating": 4.2,
                "publishers": [
                    {
                        "name": "PublisherName"
                    }
                ],
                "description": "Game description",
                "playtime": 100
            }
            """.data(using: .utf8)!,
            .success
        )
        
        let result = await interactor.getGameDetail(id: "1")
        
        switch result {
        case .success(let gameDetail):
            XCTAssertEqual(gameDetail, GameDetailModel(
                game: GameModel(
                    id: "1",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                publisher: "PublisherName",
                playCount: 100,
                gameDescription: "Game description"
            ), "Game detail should match")
        case .failure(let error):
            XCTFail("Failed with error: \(error)")
        }
    }
}
