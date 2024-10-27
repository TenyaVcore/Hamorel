//
//  MusicItemCollection+.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/10/27.
//

import MusicKit

extension MusicItemCollection<Song> {
    func toMusicSyncSongCollection() -> [MusicSyncSong] {
        let appleMusicModel = AppleMusicLibraryModel()
        var result: [MusicSyncSong] = []
        self.forEach { song in
            let id = try? appleMusicModel.getCatalogID(from: song)
            let musicSyncSong = MusicSyncSong(title: song.title, artist: song.artistName, appleMusicID: id)
            result.append(musicSyncSong)
        }
        return result
    }
}
