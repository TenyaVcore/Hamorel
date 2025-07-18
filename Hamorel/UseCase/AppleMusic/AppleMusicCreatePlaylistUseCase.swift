//
//  AppleMusicCreatePlaylistUseCase.swift
//  Hamorel
//
//  Created by 田川展也 on 12/22/R6.
//

import Foundation
import MusicKit

struct AppleMusicCreatePlaylistUseCase {
    func createPlaylist(from songs: [HamorelSong], playlistName: String) throws {
        Task {
            let musicItemCollection = await convertToMusicItemCollection(from: songs)
            try await MusicLibrary.shared.createPlaylist(name: playlistName, items: musicItemCollection)
        }
    }
    
    func convertToMusicItemCollection(from HamorelSongs: [HamorelSong]) async -> MusicItemCollection<Song> {
        var songs: [Song] = []
        
        await withTaskGroup(of: Song?.self) { group in
            for song in HamorelSongs {
                // Apple Music IDがあればそれを使って曲を取得、なければアーティスト名と曲名で検索
                group.addTask {
                    do {
                        if let catalogID = song.appleMusicID {
                            return try await getSong(from: catalogID)
                        } else {
                            return try await getSong(artist: song.artist, title: song.title)
                        }
                    } catch {
                        print("song convert error: \(error)")
                        return nil
                    }
                }
                for await song in group {
                    if let song {
                        songs.append(song)
                    }
                }
            }
        }
        return MusicItemCollection(songs)
    }
    
    
    private func getSong(from catalogID: String) async throws -> Song {
        var request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(catalogID))
        request.limit = 1
        let response = try await request.response()
        return response.items[0]
    }
    
    private func getSong(artist: String, title: String) async throws -> Song {
        var request = MusicCatalogSearchRequest(term: "\(artist) \(title)", types: [Song.self])
        request.limit = 1
        let response = try await request.response()
        
        guard let song = response.songs.first else {
            throw FetchError.songNotFound
        }
        // アーティスト名と曲名が完全に一致するか確認
        guard song.title.lowercased() == title.lowercased() &&
                song.artistName.lowercased() == artist.lowercased() else {
            throw FetchError.songMismatch
        }
        return song
    }
    
    enum FetchError: Error {
        case songNotFound
        case songMismatch
    }
}
