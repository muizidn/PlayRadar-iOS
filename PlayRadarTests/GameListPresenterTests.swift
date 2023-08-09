//
//  PlayRadarTests.swift
//  PlayRadarTests
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import XCTest
import Combine
@testable import PlayRadar

class GameListPresenterTests: XCTestCase {

    var presenter: GameListPresenter!
    var stubInteractor: StubGameListInteractor!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        stubInteractor = StubGameListInteractor()
        presenter = GameListPresenter(interactor: stubInteractor)
    }

    override func tearDown() {
        cancellables.removeAll()
        presenter = nil
        super.tearDown()
    }

    func testLoadGames() async {
        var games = [GameViewModel]()
        
        presenter.games
            .sink { _games in
                games = _games
            }
            .store(in: &cancellables)
        
        await presenter.loadGames()
        
        XCTAssertEqual(games, [
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(),
                rating: 4.2)
        ])
    }
    
    func testSearchGames() async {
        var games = [GameViewModel]()
        
        presenter.games
            .sink { _games in
                games = _games
            }
            .store(in: &cancellables)
        
        await presenter.searchGames(query: "The World Voyage")
        
        XCTAssertEqual(games, [
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "The World Voyage 3 USA Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "The World Voyage 3 USA Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "The World Voyage 3 USA Version",
                releaseDate: Date(),
                rating: 4.2)
        ])
    }
}

extension GameViewModel: Equatable {
    public static func == (lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        return lhs.coverImage == rhs.coverImage &&
            lhs.title == rhs.title &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.rating == rhs.rating
    }
}

extension GameViewModel: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        GameViewModel {
          coverImage:\(coverImage?.description ?? "nil")
          title:\(title)
          releaseDate:\(releaseDate)
          rating:\(rating)
        }
        """
    }
}

final class StubGameListInteractor: GameListInteractor {
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        return .success(.init(data: [
            GameModel(
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                release: Date(),
                rating: 4.2),
            GameModel(
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                release: Date(),
                rating: 4.2),
            GameModel(
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                release: Date(),
                rating: 4.2)
        ], page: page, count: 3))
    }
}
