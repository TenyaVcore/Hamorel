//
//  HamorelSongModel.swift
//  Hamorel
//
//  Created by 田川展也 on R 6/08/02.
//

struct HamorelSong: Codable, Equatable {
    var title: String
    var artist: String
    var appleMusicID: String?

    static func == (lhs: HamorelSong, rhs: HamorelSong) -> Bool {
        lhs.title == rhs.title && lhs.artist == rhs.artist
    }
}
