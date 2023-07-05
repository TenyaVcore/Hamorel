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
    
    var storeModel = FirestoreModel()
    var musicModel = AppleMusicLibraryModel()
    @Published var errorMessage = ""
    
    func createsPlaylist(roomPin: Int, usersData: [UserData],completion: @escaping (Result<String,Error>) -> Void){
        var songs = MusicItemCollection<Song>()
        var downloadData = [MusicItemCollection<Song>]()
        storeModel.downloadData(roomPin: roomPin, usersData: usersData) { [self] result in
            switch result {
            case .success(let userSongs):
                downloadData = userSongs
                let count = downloadData.count
                songs = downloadData[0]
                
                for i in 1..<count{
                    songs = musicModel.merge(item1: songs, item2: downloadData[i])
                }
                
                
                let mergedSongs = songs
                
                Task{try await MusicLibrary.shared.createPlaylist(name: "Music Sync Playlist", items: mergedSongs )}
                completion(.success("name"))
                
            case .failure(let error):
                print("error: \(error)")
                errorMessage = error.localizedDescription
                completion(.failure(error))
            }
        }
        
    }
}
