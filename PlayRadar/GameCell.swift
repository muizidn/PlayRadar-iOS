//
//  GameCell.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import UIKit

class GameCell: UITableViewCell {
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let starImageView: UIView = {
        let label = UILabel()
        label.text = "⭐️"
        return label
    }()
    
    let ratingLabel: UILabel = {
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
        
        // Create layout constraints
        let spacing: CGFloat = 8
        
        // coverImageView constraints
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            coverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -spacing*2),
            coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor, multiplier: 1.2),
        ])
        
        // titleLabel constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // releaseDateLabel constraints
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // starImageView constraints
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: spacing),
            starImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // ratingLabel constraints
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: spacing),
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: spacing),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: spacing)
        ])
        
    }
    
    func configure(with game: GameViewModel) {
        if let image = game.coverImage {
            coverImageView.setImage(withURL: image)
        }
        titleLabel.text = game.title
        releaseDateLabel.text = game.releaseDate.description
        ratingLabel.text = game.rating.description
    }
}

#if DEBUG
import SwiftUI

struct GameCell_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            let view = GameCell(style: .default, reuseIdentifier: "foo")
            view.configure(with: GameViewModel(coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"), title: "BioShock 2 Remastered Japan Version", releaseDate: Date(), rating: 4.2))
            return view
        }
        .frame(height: 150)
    }
}
#endif
