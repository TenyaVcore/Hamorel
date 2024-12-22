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
    let syncModel = MusicSyncSongModel()

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
            Button("並行に取得しプレイリスト作成") {
                Task {
                    do {
                        let songs = try await model.loadLibrary(limit: 0)
                        print("songs")
                        print(songs)
                        let syncSongs = songs.toMusicSyncSongCollection()
                        print("syncSongs")
                        print(syncSongs)
                        let ItemCollection = await syncSongs.toMusicItemCollection()
                        print("ItemCollection")
                        print(ItemCollection)
                        try model.createPlaylist(from: ItemCollection)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    DebugView()
}
