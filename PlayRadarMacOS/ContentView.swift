//
//  ContentView.swift
//  PlayRadarMacOS
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import SwiftUI
import PlayRadar
import PlayRadarRemote
import PlayRadarLocal

struct ContentView: View {
    @State var items = ["Game List", "Favorite"]

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink {
                        switch item {
                        case "Game List":
                            GameListView(
                                viewModel: GameListViewModel(
                                    interactor: GameListRemoteWithLocalFallbackInteractor(
                                        remote: RemoteGameListInteractor(),
                                        local: CoreDataLocalGameListInteractor()
                                    )
                                )
                            )
                        default:
                            Text("\(item) Unimplemented")
                        }
                    } label: {
                        Text(item)
                    }
                }
            }
            Text("Select an item")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
