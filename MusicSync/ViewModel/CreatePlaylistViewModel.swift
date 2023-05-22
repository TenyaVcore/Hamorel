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

class CreatePlaylistViewModel: ObservableObject {
    
    var model = FirestoreModel()
    var musicModel = AppleMusicLibraryModel()
    
    func createsPlaylist(roomPin: Int, usersData: [UserData]){
        var songs: MusicItemCollection<Song>
        let downloadData = model.downloadData(roomPin: roomPin, usersData: usersData)
        let count = downloadData.count
        songs = downloadData[0]
        
        for i in 1..<count{
            songs = musicModel.merge(item1: songs, item2: downloadData[i])
        }
        
        let completeSongs = songs
        
        Task{try await MusicLibrary.shared.createPlaylist(name: "created Playlist", items: completeSongs )}
        print("プレイリスト作りました！")
    }
}
