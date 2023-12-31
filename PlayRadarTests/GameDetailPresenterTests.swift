//
//  PlayRadarTests.swift
//  PlayRadarTests
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import XCTest
import Combine
@testable import PlayRadar

class GameDetailPresenterTests: XCTestCase {

    var presenter: GameDetailPresenter!
    var stubDetailInteractor: StubGameDetailInteractor!
    var stubFavoriteInteractor: StubGameFavoriteInteractor!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        stubDetailInteractor = StubGameDetailInteractor()
        stubFavoriteInteractor = StubGameFavoriteInteractor()
        presenter = GameDetailPresenter(
            game: GameModel(
                id: "1",
                title: "",
                release: Date(),
                rating: 1),
            detailInteractor: stubDetailInteractor,
            favoriteInteractor: stubFavoriteInteractor
        )
    }

    override func tearDown() {
        cancellables.removeAll()
        presenter = nil
        super.tearDown()
    }
    
    func testLoadGameDetailUseInteractorDetail() async throws {
        var detail: GameDetailModel! = nil
        
        presenter.detail.sink { _detail in
            detail = _detail
        }
        .store(in: &cancellables)
        
        stubDetailInteractor.getGameDetailResult = .success(
            .init(
                game: .init(
                    id: "1",
                    title: "New Title Updated",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 12),
                publisher: "Publisher A",
                playCount: 21,
                gameDescription: "Foobar")
        )
        
        presenter.getGameDetail()
        
        try await Task.sleep(for: .seconds(1))
        
        XCTAssertEqual(detail.game, .init(
            id: "1",
            title: "New Title Updated",
            release: Date(timeIntervalSince1970: 0),
            rating: 12)
        )
        XCTAssertEqual(detail.playCount, 21)
        XCTAssertEqual(detail.gameDescription, "Foobar")
        XCTAssertEqual(detail.publisher, "Publisher A")
    }
    
    func testLoadGameDetailGetFavoriteCallInteractorGetFavorite_True() async throws {
        var isFavorite = false
        
        presenter.isFavorite.sink { _isFavorite in
            isFavorite = _isFavorite
        }
        .store(in: &cancellables)
        
        stubFavoriteInteractor.getFavoriteResult = true
        
        presenter.getFavorite()
        
        try await Task.sleep(for: .seconds(1))
        
        XCTAssertTrue(isFavorite)
    }
    
    func testLoadGameDetailGetFavoriteCallInteractorGetFavorite_False() async throws {
        var isFavorite = false
        
        presenter.isFavorite.sink { _isFavorite in
            isFavorite = _isFavorite
        }
        .store(in: &cancellables)
        
        stubFavoriteInteractor.getFavoriteResult = false
        
        presenter.getFavorite()
        
        try await Task.sleep(for: .seconds(1))
        
        XCTAssertFalse(isFavorite)
    }
    
    func testSetFavoriteCallInteractorSetFavorite_True() async throws {
        var isFavorite = false
        
        presenter.isFavorite.sink { _isFavorite in
            isFavorite = _isFavorite
        }
        .store(in: &cancellables)
        
        stubFavoriteInteractor.getFavoriteResult = false
        presenter.getFavorite()
        try await Task.sleep(for: .seconds(1))
        presenter.toggleFavorite()
        try await Task.sleep(for: .seconds(1))
        
        XCTAssertTrue(isFavorite)
        XCTAssertTrue(stubFavoriteInteractor.setFavoriteValue)
    }
    
    func testSetFavoriteCallInteractorSetFavorite_False() async throws {
        var isFavorite = false
        
        presenter.isFavorite.sink { _isFavorite in
            isFavorite = _isFavorite
        }
        .store(in: &cancellables)
        
        stubFavoriteInteractor.getFavoriteResult = true
        presenter.getFavorite()
        try await Task.sleep(for: .seconds(1))
        presenter.toggleFavorite()
        try await Task.sleep(for: .seconds(1))
        
        XCTAssertFalse(isFavorite)
        XCTAssertFalse(stubFavoriteInteractor.setFavoriteValue)
    }
}


final class StubGameDetailInteractor: GameDetailInteractor {
    var getGameDetailResult: Result<GameDetailModel, Error>! = nil
    func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
        return getGameDetailResult
    }
}

final class StubGameFavoriteInteractor: FavoriteGameInteractor {
    var getFavoriteResult = false
    func getFavorite(id: String) async -> Bool {
        return getFavoriteResult
    }
    
    var setFavoriteValue = false
    func setFavorite(id: String, favorite: Bool) async {
        setFavoriteValue = favorite
    }
}
