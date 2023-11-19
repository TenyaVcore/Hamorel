//
//  CreatePlaylistViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit
import Firebase
import FirebaseFirestoreSwift

@MainActor
class CreatePlaylistViewModel: ObservableObject {
    var storeModel = FirestoreModelAsync()
    var musicModel = AppleMusicLibraryModel()

    @State var isLoading = true

    func downloadSongs(roomPin: String) {
    var songs: MusicItemCollection<Song> = []
        Task {
            do {
                let users = try await storeModel.downloadRoomData(roomPin: roomPin)
                print(users)
                let downloadData = try await storeModel.downloadSongs(users: users)
                let songCount = downloadData.count
                songs = downloadData[0]
                
                for i in 1..<songCount {
                    songs = musicModel.merge(item1: songs, item2: downloadData[i])
                }
                print(songs)
            } catch {
                print("error: \(error.localizedDescription)")
            
            }
        }
    }
}
