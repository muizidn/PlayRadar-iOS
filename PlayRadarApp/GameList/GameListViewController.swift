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
    
    init(presenter: IGameListPresenter, router: GameListRouter) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GameCell.self, forCellReuseIdentifier: GameCell.reuseIdentifier)
        return tableView
    }()
    
    let games: [GameViewModel] = [
        GameViewModel(
            id: "",
            coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
            title: "game box sample Title",
            releaseDate: Date(),
            rating: 4.5),
        GameViewModel(
            id: "",
            coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
            title: "game box sample Title",
            releaseDate: Date(),
            rating: 4.5),
        GameViewModel(
            id: "",
            coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
            title: "game box sample Title",
            releaseDate: Date(),
            rating: 4.5)
    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GameCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.launchDetail(game: presenter.getGame(at: indexPath.row))
    }
}

#if DEBUG
import SwiftUI

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
        func getGame(at index: Int) -> GameModel {
            fatalError()
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
