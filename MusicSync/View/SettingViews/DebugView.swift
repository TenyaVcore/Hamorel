//
//  TestView.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/10/05.
//

import SwiftUI
import MusicKit

struct DebugView<Repo: RoomDBProtocol>: View {
    @State var song: Song?
    @State var artistText: String = ""
    @State var titleText: String = ""
    let loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    let createPlaylistUseCase = AppleMusicCreatePlaylistUseCase()
    let syncModel = MusicSyncSongUseCase()

    var body: some View {
        List {
            Text("title: " + (song?.title ?? ""))
            Text("artist: " + (song?.artistName ?? ""))
            TextField("artist", text: $artistText)
            TextField("title", text: $titleText)

//            Button("曲を検索") {
//                Task {
//                    do {
//                        song = try await createPlaylistUseCase.getSong(artist: artistText, title: titleText)
//                    } catch {
//                        print(error)
//                    }
//                }
//            }

//            Button("プレイリスト作成") {
//                do {
//                    try createPlaylistUseCase.createPlaylist(
//                        from: loadLibraryUseCase.convertToMusicSyncSongCollection(from: [song!]))
//
//                } catch {
//                    print(error)
//                }
//            }

            Button("ルーム作成") {
                Task {
                    do {
                        try await Repo
                            .createRoom(roomPin: 100000, user: UserData(id: "111", name: "test"))
                    } catch { print(error) }
                }
            }
        }
    }
}

#Preview {
    DebugView<FirestoreRepository>()
}
