//
//  MusicSyncSongModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/08/02.
//

struct MusicSyncSong: Codable, Equatable {
    var title: String
    var artist: String
    var appleMusicID: String?

    static func == (lhs: MusicSyncSong, rhs: MusicSyncSong) -> Bool {
        lhs.title == rhs.title && lhs.artist == rhs.artist
    }
}
