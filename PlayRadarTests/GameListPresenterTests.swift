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
                id: "1",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "1",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "1",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2)
        ])
    }
    
    func testLoadNextPage_1_2() async {
        var games = [GameViewModel]()
        
        presenter.games
            .sink { _games in
                games.append(contentsOf: _games)
            }
            .store(in: &cancellables)
        
        await presenter.loadGames()
        await presenter.loadGames()
        
        XCTAssertEqual(games, [
            GameViewModel(
                id: "1",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "1",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "1",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "4",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "5",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2)
        ])
        XCTAssertEqual(stubInteractor.loadedPages, [1,2])
    }
    
    func testLoadPage_onlyLoadWhenNextPageIsTrue() async {
        var games = [GameViewModel]()
        
        presenter.games
            .sink { _games in
                games.append(contentsOf: _games)
            }
            .store(in: &cancellables)
        
        await presenter.loadGames()
        await presenter.loadGames()
        await presenter.loadGames()
        
        XCTAssertEqual(games.map({ $0.id }), [
            "1","2","3","4","5"
        ])
        XCTAssertEqual(stubInteractor.loadedPages, [1,2])
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
                id: "1",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "2",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameViewModel(
                id: "3",
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(timeIntervalSince1970: 0),
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
    var loadedPages: [Int] = []
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        
        loadedPages.append(page)
        
        if page == 1 {
            return .success(.init(data: [
                GameModel(
                    id: "1",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    publisher: "Microsoft Game Studio",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                GameModel(
                    id: "2",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    publisher: "Electronic Arts",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                GameModel(
                    id: "3",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    publisher: "Kyoto Game Studio",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
            ], page: page, count: 3, hasNext: true))
        } else {
            return .success(.init(data: [
                GameModel(
                    id: "4",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    publisher: "Microsoft Game Studio",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
                GameModel(
                    id: "5",
                    cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "BioShock 2 Remastered Japan Version",
                    publisher: "Electronic Arts",
                    release: Date(timeIntervalSince1970: 0),
                    rating: 4.2),
            ], page: page, count: 2, hasNext: false))
        }
    }
    
    func searchGames(query: String) async -> Result<[GameModel], Error> {
        return .success([
            GameModel(
                id: "1",
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                publisher: "Microsoft Game Studio",
                release: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameModel(
                id: "2",
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                publisher: "Electronic Arts",
                release: Date(timeIntervalSince1970: 0),
                rating: 4.2),
            GameModel(
                id: "3",
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                publisher: "Kyoto Game Studio",
                release: Date(timeIntervalSince1970: 0),
                rating: 4.2),
        ])
    }
}
