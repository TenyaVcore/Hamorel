//
//  MusicSyncSongUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/22/R6.
//

struct MusicSyncSongModel {
    func merge(item1: [MusicSyncSong], item2: [MusicSyncSong]) -> [MusicSyncSong] {
        var mergedItem: [MusicSyncSong] = []
        let (longerItem, smallerItem) = item1.count > item2.count ? (item1, item2) : (item2, item1)

        for i in 0 ..< smallerItem.count {
            for j in 0 ..< longerItem.count where longerItem[j] == smallerItem[i] {
                mergedItem.append(smallerItem[i])
                break
            }
        }
        return mergedItem
    }
}
