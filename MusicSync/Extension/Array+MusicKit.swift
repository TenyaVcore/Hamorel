//
//  Array+MusicKit.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/10/27.
//

import MusicKit

extension Array where Element == MusicSyncSong {
    func toMusicItemCollection() async -> MusicItemCollection<Song> {
        let appleMusicLibraryModel = AppleMusicLibraryModel()
        var songs: [Song] = []

        await withTaskGroup(of: Song?.self) { group in
            for song in self {
                group.addTask {
                    if let catalogID = song.appleMusicID {
                        return try? await appleMusicLibraryModel.getSong(from: catalogID)
                    } else {
                        return try? await appleMusicLibraryModel.getSong(artist: song.artist, title: song.title)
                    }
                }
            }
            for await song in group {
                if let song = song {
                    songs.append(song)
                }
            }
        }
        return MusicItemCollection(songs)
    }
}
