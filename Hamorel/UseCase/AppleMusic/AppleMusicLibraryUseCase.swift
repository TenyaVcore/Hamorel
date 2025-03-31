//
//  AppleMusicLibraryUseCase.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/05/22.
//

import Foundation.NSJSONSerialization
import MusicKit

struct AppleMusicLoadLibraryUseCase {
    func loadLibrary(limit: Int) async throws -> [HamorelSong] {
        var request = MusicLibraryRequest<Song>()
        request.limit = limit
        let response = try await request.response()
        let songs = response.items

        let HamorelSongs = convertToHamorelSongCollection(from: songs)
        return HamorelSongs
    }

    func convertToHamorelSongCollection(from songs: MusicItemCollection<Song>) -> [HamorelSong] {
        var HamorelSongs: [HamorelSong] = []
        songs.forEach { song in
            let id = try? getCatalogID(from: song)
            let HamorelSong = HamorelSong(title: song.title, artist: song.artistName, appleMusicID: id)
            HamorelSongs.append(HamorelSong)
        }
        return HamorelSongs
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
