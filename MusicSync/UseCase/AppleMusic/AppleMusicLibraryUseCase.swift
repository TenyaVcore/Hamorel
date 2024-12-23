//
//  AppleMusicLibraryUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import Foundation
import MusicKit

struct AppleMusicLoadLibraryUseCase {
    func loadLibrary(limit: Int) async throws -> [MusicSyncSong] {
        var request = MusicLibraryRequest<Song>()
        request.limit = limit
        let response = try await request.response()
        let songs = response.items

        let musicSyncSongs = convertToMusicSyncSongCollection(from: songs)
        return musicSyncSongs
    }

    func convertToMusicSyncSongCollection(from songs: MusicItemCollection<Song>) -> [MusicSyncSong] {
        var musicSyncSongs: [MusicSyncSong] = []
        songs.forEach { song in
            let id = try? getCatalogID(from: song)
            let musicSyncSong = MusicSyncSong(title: song.title, artist: song.artistName, appleMusicID: id)
            musicSyncSongs.append(musicSyncSong)
        }
        return musicSyncSongs
    }

    private func getCatalogID(from song: Song) throws -> String {
        // 一度JSONにパースしてから、CatalogIDを取得する
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(song)
        let musicMetaData = try JSONDecoder().decode(MusicMetaData.self, from: jsonData)
        let catalogID = musicMetaData.meta.musicKit_identifierSet.catalogID
        return catalogID.value
    }

    // Songのメタデータをパースするモデル
    private struct MusicMetaData: Codable {
        let meta: Meta

        // swiftlint:disable nesting
        struct Meta: Codable {
            let musicKit_identifierSet: MusicKitIdentifierSet
        }

        struct MusicKitIdentifierSet: Codable {
            let catalogID: CatalogID
        }

        struct CatalogID: Codable {
            let kind: String
            let value: String
        }
        // swiftlint:enable nesting
    }

}
