//
//  TestView.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/10/05.
//

import SwiftUI
import MusicKit

struct DebugView: View {
    @State var song: Song?
    @State var artistText: String = ""
    @State var titleText: String = ""
    let model = AppleMusicLibraryModel()

    var body: some View {
        List {
            Text("title: " + (song?.title ?? ""))
            Text("artist: " + (song?.artistName ?? ""))
            TextField("artist", text: $artistText)
            TextField("title", text: $titleText)
            Button("曲を検索") {
                Task {
                    do {
                        song = try await model.getSong(artist: artistText, title: titleText)
                    } catch {
                        print(error)
                    }
                }
            }
            Button("プレイリスト作成") {
                do {
                    try model.createPlaylist(from: MusicItemCollection(arrayLiteral: song!))
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    DebugView()
}
