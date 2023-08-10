//
//  GameDetailRemoteWithLocalFallbackInteractorTests.swift
//  PlayRadarAppTests
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import XCTest
@testable import PlayRadarApp
import PlayRadar

class GameDetailRemoteWithLocalFallbackInteractorTests: XCTestCase {
    class StubRemote: GameDetailInteractor {
        var getGameDetailResult: Result<String, Error> = .success("RemoteDetail")
        var getGameDetailCalled = false
        func getGameDetail(id: String) async -> Result<String, Error> {
            getGameDetailCalled = true
            return getGameDetailResult
        }
    }
    
    class StubLocal: LocalGameDetailInteracotr {
        var getGameDetailCalled = false
        var saveGameDetailCalled = false
        var savedId: String = ""
        var savedContentDescription: String = ""
        var getGameDetailResult: Result<String, Error> = .success("LocalDetail")
        
        func saveGameDetail(id: String, contentDescription: String) async -> Result<Void, Error> {
            saveGameDetailCalled = true
            savedId = id
            savedContentDescription = contentDescription
            return .success(())
        }
        
        func getGameDetail(id: String) async -> Result<String, Error> {
            getGameDetailCalled = true
            return getGameDetailResult
        }
    }
    
    func testRemoteSuccess() async {
        let mockRemote = StubRemote()
        let mockLocal = StubLocal()
        
        let interactor = GameDetailRemoteWithLocalFallbackInteractor(remote: mockRemote, local: mockLocal)
        
        let result = await interactor.getGameDetail(id: "123")
        
        XCTAssertTrue(checkResultEqual(result, .success("RemoteDetail")))
        XCTAssertTrue(mockRemote.getGameDetailCalled)
        XCTAssertTrue(mockLocal.saveGameDetailCalled)
    }
    
    func testRemoteFailureLocalSuccess() async {
        let mockRemote = StubRemote()
        let mockLocal = StubLocal()
        
        mockRemote.getGameDetailResult = .failure(FakeError("remote"))
        
        let interactor = GameDetailRemoteWithLocalFallbackInteractor(remote: mockRemote, local: mockLocal)
        
        let result = await interactor.getGameDetail(id: "123")
        
        XCTAssertTrue(checkResultEqual(result, .success("LocalDetail")))
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

func checkResultEqual(_ lhs: Result<String, Error>,_ rhs: Result<String, Error>) -> Bool {
    switch (lhs, rhs) {
    case let (.success(lhsValue), .success(rhsValue)):
        return lhsValue == rhsValue
    case let (.failure(lhsError), .failure(rhsError)):
        return lhsError.localizedDescription == rhsError.localizedDescription
    default:
        return false
    }
}
