//
//  MusicSyncSongModelTest.swift
//  MusicSyncTests
//
//  Created by 田川展也 on R 6/08/12.
//

import XCTest
@testable import MusicSync

class MusicSyncSongModelTests: XCTestCase {

    var model: MusicSyncSongModel!

    override func setUp() {
        super.setUp()
        model = MusicSyncSongModel()
    }

    func testMergeWithEqualArrays() {
        let songs1 = [
            MusicSyncSong(title: "Song1", artistName: "Artist1", appleMusicID: "1"),
            MusicSyncSong(title: "Song2", artistName: "Artist2", appleMusicID: "2")
        ]
        let songs2 = [
            MusicSyncSong(title: "Song1", artistName: "Artist1", appleMusicID: "3"),
            MusicSyncSong(title: "Song2", artistName: "Artist2", appleMusicID: "4")
        ]

        let merged = model.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 2)
        XCTAssertEqual(merged[0].title, "Song1")
        XCTAssertEqual(merged[0].artistName, "Artist1")
        XCTAssertEqual(merged[1].title, "Song2")
        XCTAssertEqual(merged[1].artistName, "Artist2")
    }

    func testMergeWithDifferentArrays() {
        let songs1 = [
            MusicSyncSong(title: "Song1", artistName: "Artist1", appleMusicID: "1"),
            MusicSyncSong(title: "Song2", artistName: "Artist2", appleMusicID: "2")
        ]
        let songs2 = [
            MusicSyncSong(title: "Song3", artistName: "Artist3", appleMusicID: "3"),
            MusicSyncSong(title: "Song4", artistName: "Artist4", appleMusicID: "4")
        ]

        let merged = model.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 0)
    }

    func testMergeWithPartiallyOverlappingArrays() {
        let songs1 = [
            MusicSyncSong(title: "Song1", artistName: "Artist1", appleMusicID: "1"),
            MusicSyncSong(title: "Song2", artistName: "Artist2", appleMusicID: "2"),
            MusicSyncSong(title: "Song3", artistName: "Artist3", appleMusicID: "3")
        ]
        let songs2 = [
            MusicSyncSong(title: "Song2", artistName: "Artist2", appleMusicID: "4"),
            MusicSyncSong(title: "Song3", artistName: "Artist3", appleMusicID: "5"),
            MusicSyncSong(title: "Song4", artistName: "Artist4", appleMusicID: "6")
        ]

        let merged = model.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 2)
        XCTAssertEqual(merged[0].title, "Song2")
        XCTAssertEqual(merged[0].artistName, "Artist2")
        XCTAssertEqual(merged[1].title, "Song3")
        XCTAssertEqual(merged[1].artistName, "Artist3")
    }

    func testMergeWithEmptyArrays() {
        let songs1: [MusicSyncSong] = []
        let songs2: [MusicSyncSong] = []

        let merged = model.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 0)
    }
}
