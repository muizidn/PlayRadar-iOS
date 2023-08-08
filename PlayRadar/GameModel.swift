//
//  GameViewModel.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import Foundation

final class GameViewModel {
    init(coverImage: URL?, title: String, releaseDate: Date, rating: Double) {
        self.coverImage = coverImage
        self.title = title
        self.releaseDate = releaseDate
        self.rating = rating
    }
    
    let coverImage: URL?
    let title: String
    let releaseDate: Date
    let rating: Double
}
