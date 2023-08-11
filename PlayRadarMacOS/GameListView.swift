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
                HStack {
                    TextField("Search any games you want", text: $viewModel.searchText)
                    Button("Search") {
                        viewModel.searchGames()
                    }
                }
                List {
                    ForEach(viewModel.games) { game in
                        GameCellView(game: game)
                            .onAppear {
                                viewModel.loadNextGamesIfNeeded(game)
                            }
                        
                        // fixme: must be better logic
                        // this is required so that cell.onAppear doesn't call
                        // the loadNextGamesIfNeeded continuously
                        if game.id == viewModel.games.last?.id {
                            Color.clear.frame(height: 1)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                if viewModel.isLoadingNextGames {
                    Text("Loading next games")
                        .padding()
                }
            }
            .frame(minWidth: 400, minHeight: 300)
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
