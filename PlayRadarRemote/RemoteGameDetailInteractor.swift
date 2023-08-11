//
//  RemoteGameDetailInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

public final class RemoteGameDetailInteractor: GameDetailInteractor {
    private let decoderDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = .gmt
        return df
    }()
    
    private let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    public func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
        do {
            let (data, response) = try await httpClient.performRequest(API.detail(id: id).createUrlRequest())
            guard response == .success else {
                return .failure(NSError(domain: "\(Self.self)", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "problem!"
                ]))
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(decoderDateFormatter)
            let resp = try decoder.decode(GameDetailCodable.self, from: data)
            return .success(.init(
                game: GameModel(
                    id: resp.id.description,
                    cover: resp.backgroundImage.flatMap({ URL(string: $0) }),
                    title: resp.name,
                    release: resp.released ?? Date(),
                    rating: resp.rating),
                publisher: resp.publishers.first?.name ?? "",
                playCount: resp.playCount,
                gameDescription: resp.gameDescription))
        } catch {
            return .failure(error)
        }
    }
}

private struct PublisherCodable: Codable {
    let name: String
}

private struct GameDetailCodable: Codable {
    let id: Int
    let name: String
    let backgroundImage: String?
    let released: Date?
    let rating: Double
    let publishers: [PublisherCodable]
    let gameDescription: String
    let playCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, backgroundImage = "background_image", released = "released_at", rating, publishers
        case gameDescription = "description"
        case playCount = "playtime"
    }
}
