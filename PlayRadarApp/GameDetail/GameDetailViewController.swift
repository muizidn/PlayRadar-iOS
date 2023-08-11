//
//  GamePresenterViewController.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import Combine
import PlayRadar

class GameDetailViewController: UIViewController {
    let presenter: GameDetailPresenter
    
    private var cancellables = Set<AnyCancellable>()
    
    init(presenter: GameDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let publisherLabel: UILabel = {
        let label = UILabel()
        label.text = "Rockstar Game"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Space Colonization Odyssey US Edition Anniversary 3"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Released at 1997-10-10"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let ratingImageView: UIView = {
        let label = UILabel()
        label.text = "⭐️"
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.5"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let playCountLabel: UILabel = {
        let label = UILabel()
        label.text = "100 played"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        presenter.isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isFavorite in
                navigationItem.rightBarButtonItem!.image =
                isFavorite ? UIImage(named: "Favorite_fill") : UIImage(named: "Favorite")
            }
            .store(in: &cancellables)
        
        presenter.detail
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] detail in
                if let url = detail.game.cover {
                    coverImageView.setImage(withURL: url)
                }
                gameTitleLabel.text = detail.game.title
                releaseDateLabel.text = detail.game.release.description
                ratingLabel.text = detail.game.rating.description
                publisherLabel.text = detail.publisher
                playCountLabel.text = detail.playCount.description
                descriptionLabel.attributedText = .from(html: detail.gameDescription, withFont: descriptionLabel.font)
            }
            .store(in: &cancellables)
        
        presenter.getGameDetail()
        presenter.getFavorite()
    }
    
    @objc private func toggleFavorite() {
        presenter.toggleFavorite()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Favorite"), style: .plain, target: self, action: #selector(toggleFavorite))
        title = "Detail"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(publisherLabel)
        contentView.addSubview(gameTitleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingStackView)
        ratingStackView.addArrangedSubview(ratingImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(playCountLabel)
        contentView.addSubview(descriptionLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 200),
            
            publisherLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            publisherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            publisherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            gameTitleLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 10),
            gameTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gameTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            releaseDateLabel.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingStackView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

extension NSAttributedString {
    static func from(html: String, withFont font: UIFont) -> NSAttributedString? {
        guard let data = html.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            
            // Apply the label's font to the entire attributed string
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            mutableAttributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: mutableAttributedString.length))
            
            return mutableAttributedString
        } catch {
            print("Error converting HTML to NSAttributedString: \(error)")
            return nil
        }
    }
}

#if DEBUG
import SwiftUI

struct GameDetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        ControllerPreviewContainer {
            let vc = GameDetailViewController(
                presenter: GameDetailPresenter(
                    game: GameModel(
                        id: "1",
                        title: "foo",
                        release: Date(timeIntervalSince1970: 0),
                        rating: 2),
                    detailInteractor: DummyDetailInteractor(),
                    favoriteInteractor: DummyFavoriteInteractor()
                )
            )
            vc.viewDidLoad()
            return UINavigationController(rootViewController: vc)
        }
    }
    
    class DummyDetailInteractor: GameDetailInteractor {
        func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
            fatalError()
        }
    }
    
    class DummyFavoriteInteractor: FavoriteGameInteractor {
        func setFavorite(id: String, favorite: Bool) async {
            fatalError()
        }
        
        func getFavorite(id: String) async -> Bool {
            fatalError()
        }
    }
}
#endif
