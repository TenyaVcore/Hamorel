//
//  MusicSyncSongModelTest.swift
//  MusicSyncTests
//
//  Created by 田川展也 on R 6/08/12.
//

import XCTest
@testable import MusicSync

class MusicSyncSongModelTests: XCTestCase {

    var useCase: MusicSyncSongUseCase!

    override func setUp() {
        super.setUp()
        useCase = MusicSyncSongUseCase()
    }

    func testMergeWithEqualArrays() {
        let songs1 = [
            MusicSyncSong(title: "Song1", artist: "Artist1", appleMusicID: "1"),
            MusicSyncSong(title: "Song2", artist: "Artist2", appleMusicID: "2")
        ]
        let songs2 = [
            MusicSyncSong(title: "Song1", artist: "Artist1", appleMusicID: "3"),
            MusicSyncSong(title: "Song2", artist: "Artist2", appleMusicID: "4")
        ]

        let merged = useCase.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 2)
        XCTAssertEqual(merged[0].title, "Song1")
        XCTAssertEqual(merged[0].artist, "Artist1")
        XCTAssertEqual(merged[1].title, "Song2")
        XCTAssertEqual(merged[1].artist, "Artist2")
    }

    func testMergeWithDifferentArrays() {
        let songs1 = [
            MusicSyncSong(title: "Song1", artist: "Artist1", appleMusicID: "1"),
            MusicSyncSong(title: "Song2", artist: "Artist2", appleMusicID: "2")
        ]
        let songs2 = [
            MusicSyncSong(title: "Song3", artist: "Artist3", appleMusicID: "3"),
            MusicSyncSong(title: "Song4", artist: "Artist4", appleMusicID: "4")
        ]

        let merged = useCase.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 0)
    }

    func testMergeWithPartiallyOverlappingArrays() {
        let songs1 = [
            MusicSyncSong(title: "Song1", artist: "Artist1", appleMusicID: "1"),
            MusicSyncSong(title: "Song2", artist: "Artist2", appleMusicID: "2"),
            MusicSyncSong(title: "Song3", artist: "Artist3", appleMusicID: "3")
        ]
        let songs2 = [
            MusicSyncSong(title: "Song2", artist: "Artist2", appleMusicID: "4"),
            MusicSyncSong(title: "Song3", artist: "Artist3", appleMusicID: "5"),
            MusicSyncSong(title: "Song4", artist: "Artist4", appleMusicID: "6")
        ]

        let merged = useCase.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 2)
        XCTAssertEqual(merged[0].title, "Song2")
        XCTAssertEqual(merged[0].artist, "Artist2")
        XCTAssertEqual(merged[1].title, "Song3")
        XCTAssertEqual(merged[1].artist, "Artist3")
    }

    func testMergeWithEmptyArrays() {
        let songs1: [MusicSyncSong] = []
        let songs2: [MusicSyncSong] = []

        let merged = useCase.merge(item1: songs1, item2: songs2)

        XCTAssertEqual(merged.count, 0)
    }
}
