//
//  GameListView.swift
//  PlayRadarMacOS
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import SwiftUI
import PlayRadar

struct GameListView: View {
    @StateObject private var viewModel: GameListViewModel

    init(viewModel: GameListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.games) { game in
                    GameCellView(game: game)
                }
                .listStyle(PlainListStyle())
            }
            .frame(minWidth: 400, minHeight: 300)
            .searchable(text: $viewModel.searchText)
            .padding()
            .onAppear {
                viewModel.loadGames()
            }
        }
    }
}

struct GameCellView: View {
    let game: GameViewModel

    var body: some View {
        HStack {
            if let url = game.coverImage {
                AsyncImage(url: url)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .font(.headline)

                Text(game.releaseDate)
                    .foregroundColor(.secondary)

                RatingView(rating: game.rating)
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
    }
}

struct RatingView: View {
    let rating: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)

            Text(rating)
        }
        .foregroundColor(.primary)
    }
}

extension GameViewModel: Identifiable {
}
