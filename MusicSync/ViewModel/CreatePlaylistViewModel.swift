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
    var songs: MusicItemCollection<Song> = []
    var users: [String] = []

    @Published var isLoading = true
    @Published var isReturnHome = false
    @Published var isCreateError = false
    @Published var isDownloadError = false
    @Published var isSuccessCreate = false
    @Published var playlistName = "MusicSyncPlaylist"

    func downloadSongs(roomPin: String) {
        Task {
            do {
                users = try await storeModel.downloadRoomData(roomPin: roomPin)
                print(users)
                let downloadData = try await storeModel.downloadSongs(users: users)
                let songCount = downloadData.count
                songs = downloadData[0]
                for i in 1..<songCount {
                    songs = musicModel.merge(item1: songs, item2: downloadData[i])
                }
                isLoading = false
            } catch {
                print("download error: \(error.localizedDescription)")
                isDownloadError = true
            }
        }
    }
    
    func createPlaylist() {
        do {
            try musicModel.createPlaylist(from: songs, playlistName: playlistName)
        } catch {
            print("create error: \(error.localizedDescription)")
            isCreateError = true
        }
    }
}
