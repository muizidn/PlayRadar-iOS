//
//  GameViewModel.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import Foundation

public final class GameViewModel {
    private static let dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    public init(id: String, coverImage: URL?, title: String, releaseDate: Date, rating: Double) {
        self.id = id
        self.coverImage = coverImage
        self.title = title
        self.releaseDate = "Released date \(Self.dateFormatter.string(from: releaseDate))"
        if rating.hasFractionalPart {
            self.rating = rating.description
        } else {
            self.rating = Int(rating).description
        }
    }
    
    public let id: String
    public let coverImage: URL?
    public let title: String
    public let releaseDate: String
    public let rating: String
}
