//
//  GameListViewController.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import PlayRadar

class GameListViewController: UIViewController {
    
    private let presenter: IGameListPresenter
    private let router: GameListRouter
    private var cancellables = Set<AnyCancellable>()
    
    init(presenter: IGameListPresenter, router: GameListRouter) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private var games = [GameViewModel]()
    private var isLoadingNextGames = false
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GameCell.self, forCellReuseIdentifier: GameCell.reuseIdentifier)
        return tableView
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .red
        label.text = "Loading next games"
        label.isHidden = true
        return label
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        title = "Games For You"
     
        presenter.games
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] games in
                self.games = games
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        presenter.loadingNextGames
            .receive(on: DispatchQueue.main)
            .sink { [unowned self]  isLoading in
                self.isLoadingNextGames = isLoading
                self.loadingLabel.isHidden = !isLoading
            }
            .store(in: &cancellables)
        
        Task {
            await presenter.loadGames()
        }
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchField)
        view.addSubview(tableView)
        view.addSubview(loadingLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -10),
            loadingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate

extension GameListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: GameCell.reuseIdentifier,
            for: indexPath
        ) as! GameCell
        
        let game = games[indexPath.row]
        cell.configure(with: game)
        
        loadNextGamesIfNeeded(indexPath.row)
        
        return cell
    }
    
    private func loadNextGamesIfNeeded(_ row: Int) {
        if !isLoadingNextGames && row == games.count - 1 {
            isLoadingNextGames = true
            loadingLabel.isHidden = false
            Task {
                await presenter.nextGames()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GameCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.launchDetail(game: presenter.getGame(at: indexPath.row))
    }
}

extension GameListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            await presenter.searchGames(query: searchText)
        }
    }
}

#if DEBUG
import SwiftUI
import Combine

struct GameListViewController_Previews: PreviewProvider {
    static var previews: some View {
        ControllerPreviewContainer {
            let vc = GameListViewController(
                presenter: DummyPresenter(),
                router: DummyRouter()
            )
            vc.viewDidLoad()
            return vc
        }
    }
    
    class DummyPresenter: IGameListPresenter {
        var loadingNextGames: AnyPublisher<Bool, Never> { Just(false).eraseToAnyPublisher() }
        func nextGames() async {
        }
        
        var games: AnyPublisher<[GameViewModel], Never> {
            Just([
                GameViewModel(
                    id: "",
                    coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "game box sample Title",
                    releaseDate: Date(timeIntervalSince1970: 0),
                    rating: 4.5),
                GameViewModel(
                    id: "",
                    coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "game box sample Title",
                    releaseDate: Date(timeIntervalSince1970: 0),
                    rating: 4.5),
                GameViewModel(
                    id: "",
                    coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                    title: "game box sample Title",
                    releaseDate: Date(timeIntervalSince1970: 0),
                    rating: 4.5)
            ])
            .eraseToAnyPublisher()
        }
        
        func loadGames() async {
        }
        
        func getGame(at index: Int) -> GameModel {
            fatalError()
        }
        
        func searchGames(query: String) async {
        }
    }
    class DummyRouter: GameListRouter {
        func launch() -> UIViewController {
            return UIViewController()
        }
        func launchDetail(game: GameModel) {
        }
    }
}
#endif
