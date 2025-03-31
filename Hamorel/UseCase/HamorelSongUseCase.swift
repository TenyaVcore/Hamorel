//
//  HamorelSongUseCase.swift
//  Hamorel
//
//  Created by 田川展也 on 12/22/R6.
//

struct HamorelSongUseCase {
    /// MusicSongの配列をANDで足し合わせます。
    func merge(item1: [HamorelSong], item2: [HamorelSong]) -> [HamorelSong] {
        var mergedItem: [HamorelSong] = []
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
