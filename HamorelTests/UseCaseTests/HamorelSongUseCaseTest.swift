//
//  HamorelSongUseCaseTest.swift
//  HamorelTests
//
//  Created by 田川展也 on R 6/08/12.
//

import Testing
@testable import Hamorel

struct HamorelSongUseCaseTests {

    var useCase = HamorelSongUseCase()

    @Test
    func mergeWithEqualArrays() {
        let songs1 = [
            HamorelSong(title: "Song1", artist: "Artist1", appleMusicID: "1"),
            HamorelSong(title: "Song2", artist: "Artist2", appleMusicID: "2")
        ]
        let songs2 = [
            HamorelSong(title: "Song1", artist: "Artist1", appleMusicID: "3"),
            HamorelSong(title: "Song2", artist: "Artist2", appleMusicID: "4")
        ]

        let merged = useCase.merge(item1: songs1, item2: songs2)

        #expect(merged.count == 2)
        #expect(merged[0].title == "Song1")
        #expect(merged[0].artist == "Artist1")
        #expect(merged[1].title == "Song2")
        #expect(merged[1].artist == "Artist2")
    }

    @Test
    func testMergeWithDifferentArrays() {
        let songs1 = [
            HamorelSong(title: "Song1", artist: "Artist1", appleMusicID: "1"),
            HamorelSong(title: "Song2", artist: "Artist2", appleMusicID: "2")
        ]
        let songs2 = [
            HamorelSong(title: "Song3", artist: "Artist3", appleMusicID: "3"),
            HamorelSong(title: "Song4", artist: "Artist4", appleMusicID: "4")
        ]

        let merged = useCase.merge(item1: songs1, item2: songs2)

        #expect(merged.count == 0)
    }

    @Test
    func testMergeWithPartiallyOverlappingArrays() {
        let songs1 = [
            HamorelSong(title: "Song1", artist: "Artist1", appleMusicID: "1"),
            HamorelSong(title: "Song2", artist: "Artist2", appleMusicID: "2"),
            HamorelSong(title: "Song3", artist: "Artist3", appleMusicID: "3")
        ]
        let songs2 = [
            HamorelSong(title: "Song2", artist: "Artist2", appleMusicID: "4"),
            HamorelSong(title: "Song3", artist: "Artist3", appleMusicID: "5"),
            HamorelSong(title: "Song4", artist: "Artist4", appleMusicID: "6")
        ]

        let merged = useCase.merge(item1: songs1, item2: songs2)

        #expect(merged.count == 2)
        #expect(merged[0].title == "Song2")
        #expect(merged[0].artist == "Artist2")
        #expect(merged[1].title == "Song3")
        #expect(merged[1].artist == "Artist3")
    }

    func testMergeWithEmptyArrays() {
        let songs1: [HamorelSong] = []
        let songs2: [HamorelSong] = []

        let merged = useCase.merge(item1: songs1, item2: songs2)

        #expect(merged.count == 0)
    }
}
