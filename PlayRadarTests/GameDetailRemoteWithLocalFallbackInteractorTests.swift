//
//  GameDetailRemoteWithLocalFallbackInteractorTests.swift
//  PlayRadariOSTests
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import XCTest
@testable import PlayRadar

class GameDetailRemoteWithLocalFallbackInteractorTests: XCTestCase {
    class StubRemote: GameDetailInteractor {
        var getGameDetailResult: Result<GameDetailModel, Error> = .success(FakeGameDetail("RemoteDetail"))
        var getGameDetailCalled = false
        func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
            getGameDetailCalled = true
            return getGameDetailResult
        }
    }
    
    class StubLocal: LocalGameDetailInteracotr {
        var getGameDetailCalled = false
        var saveGameDetailCalled = false
        var savedId: String = ""
        var savedContentDescription: String = ""
        var getGameDetailResult: Result<GameDetailModel, Error> = .success(FakeGameDetail("LocalDetail"))
        
        func saveGameDetail(id: String, detail: GameDetailModel) async -> Result<Void, Error> {
            saveGameDetailCalled = true
            savedId = id
            savedContentDescription = detail.gameDescription
            return .success(())
        }
        
        func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
            getGameDetailCalled = true
            return getGameDetailResult
        }
    }
    
    func testRemoteSuccess() async {
        let mockRemote = StubRemote()
        let mockLocal = StubLocal()
        
        let interactor = GameDetailRemoteWithLocalFallbackInteractor(remote: mockRemote, local: mockLocal)
        
        let result = await interactor.getGameDetail(id: "123")
        
        XCTAssertTrue(checkResultEqual(result, .success(FakeGameDetail("RemoteDetail"))))
        XCTAssertTrue(mockRemote.getGameDetailCalled)
        XCTAssertTrue(mockLocal.saveGameDetailCalled)
    }
    
    func testRemoteFailureLocalSuccess() async {
        let mockRemote = StubRemote()
        let mockLocal = StubLocal()
        
        mockRemote.getGameDetailResult = .failure(FakeError("remote"))
        
        let interactor = GameDetailRemoteWithLocalFallbackInteractor(remote: mockRemote, local: mockLocal)
        
        let result = await interactor.getGameDetail(id: "123")
        
        XCTAssertTrue(checkResultEqual(result, .success(FakeGameDetail("LocalDetail"))))
        XCTAssertTrue(mockRemote.getGameDetailCalled)
        XCTAssertFalse(mockLocal.saveGameDetailCalled)
    }
    
    func testRemoteFailureLocalFailure() async {
        let mockRemote = StubRemote()
        let mockLocal = StubLocal()
        
        mockRemote.getGameDetailResult = .failure(FakeError("remote"))
        
        mockLocal.getGameDetailResult = .failure(FakeError("local"))
        
        let interactor = GameDetailRemoteWithLocalFallbackInteractor(remote: mockRemote, local: mockLocal)
        
        let result = await interactor.getGameDetail(id: "123")
        
        XCTAssertTrue(checkResultEqual(result, .failure(FakeError("remote"))))
        XCTAssertTrue(mockLocal.getGameDetailCalled)
    }
}

func FakeError(_ reason: String) -> Error {
    NSError(domain: "StubError", code: 1, userInfo: [
        NSLocalizedDescriptionKey: reason
    ])
}

func checkResultEqual(_ lhs: Result<GameDetailModel, Error>,_ rhs: Result<GameDetailModel, Error>) -> Bool {
    switch (lhs, rhs) {
    case let (.success(lhsValue), .success(rhsValue)):
        return lhsValue == rhsValue
    case let (.failure(lhsError), .failure(rhsError)):
        return lhsError.localizedDescription == rhsError.localizedDescription
    default:
        return false
    }
}

func FakeGameDetail(_ id: String) -> GameDetailModel {
    return .init(
        game: GameModel(
            id: id,
            title: id,
            release: Date(timeIntervalSince1970: 0),
            rating: 1),
        publisher: id,
        playCount: 21,
        gameDescription: id
    )
}
