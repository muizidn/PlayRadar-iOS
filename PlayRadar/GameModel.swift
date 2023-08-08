//
//  GameViewModel.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import Foundation

final class GameViewModel {
    private static let dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    init(coverImage: URL?, title: String, releaseDate: Date, rating: Double) {
        self.coverImage = coverImage
        self.title = title
        self.releaseDate = "Released date \(Self.dateFormatter.string(from: releaseDate))"
        if Self.hasFractionalPart(rating) {
            self.rating = rating.description
        } else {
            self.rating = Int(rating).description
        }
    }
    
    static private func hasFractionalPart(_ value: Double) -> Bool {
        return value != Double(Int(value))
    }
    
    let coverImage: URL?
    let title: String
    let releaseDate: String
    let rating: String
}
