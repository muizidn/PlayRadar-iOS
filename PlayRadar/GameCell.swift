//
//  GameCell.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(ratingLabel)
        
        for view in contentView.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            coverImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            starImageView.leadingAnchor.constraint(equalTo: releaseDateLabel.trailingAnchor, constant: 8),
            starImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with game: GameViewModel) {
        if let image = game.coverImage {
            coverImageView.setImage(withURL: image)
        }
        titleLabel.text = game.title
        releaseDateLabel.text = game.releaseDate.description
    }
}

#if DEBUG
import SwiftUI

struct GameTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            let view = GameTableViewCell(style: .default, reuseIdentifier: "foo")
            view.frame = .init(x: 0, y: 0, width: 100, height: 100)
            view.configure(with: GameViewModel(coverImage: nil, title: "Foo", releaseDate: Date(), rating: 10))
            return view
        }
    }
}
#endif
