//
//  GameDetailView.swift
//  PlayRadarMacOS
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import SwiftUI
import PlayRadar

struct GameDetailView: View {
    @ObservedObject var viewModel: GameDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let url = viewModel.coverImage {
                    AsyncImage(url:  url)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                }

                Text(viewModel.publisher)
                    .font(.system(size: 16))
                Text(viewModel.gameTitle)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.leading)
                Text(viewModel.releaseDate)
                    .font(.system(size: 16))
                HStack(spacing: 5) {
                    Text("⭐️")
                    Text(viewModel.rating)
                        .font(.system(size: 16))
                    Text(viewModel.playCount)
                        .font(.system(size: 16))
                }
                Text(AttributedString(viewModel.gameDescription))
                    .font(.system(size: 16))
                    .lineLimit(nil) // Allow unlimited lines
            }
            .padding(20)
        }
        .toolbar {
            Button(action: viewModel.toggleFavorite) {
                Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
            }
        }
        .onAppear {
            viewModel.getDetail()
            viewModel.getFavorite()
        }
    }
}


struct _GameDetailView: View {
    let game: GameModel
    var body: some View {
        GameDetailView(viewModel: createDetailViewModel(forGame: game))
    }
}
