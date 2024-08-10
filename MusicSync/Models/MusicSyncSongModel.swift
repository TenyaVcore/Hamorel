//
//  MusicSyncSongModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/08/02.
//

struct MusicSyncSong: Codable, Equatable {
    var title: String
    var artistName: String
    var appleMusicID: String?

    static func == (lhs: MusicSyncSong, rhs: MusicSyncSong) -> Bool{
        lhs.title == rhs.title && lhs.artistName == rhs.artistName
    }
}

struct MusicSyncSongModel {
    func merge(item1: [MusicSyncSong], item2: [MusicSyncSong]) -> [MusicSyncSong] {
        var mergedItem: [MusicSyncSong] = []

        let longerItem: [MusicSyncSong] = item1.count > item2.count ? item1 : item2
        let smallerItem: [MusicSyncSong] = item1.count <= item2.count ? item1 : item2

        for i in 0 ..< smallerItem.count {
            for j in 0 ..< longerItem.count {
                if longerItem[j].title == smallerItem[i].title && longerItem[j].artistName == smallerItem[i].artistName {
                    mergedItem.append(smallerItem[i])
                    break
                }
            }
        }
        return mergedItem
    }

}
