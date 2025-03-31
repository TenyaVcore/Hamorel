//
//  CreateRoomUseCaseTest.swift
//  HamorelTests
//
//  Created by 田川展也 on 1/29/R7.
//

import Testing
@testable import Hamorel

struct CreateRoomUseCaseTest {
    struct FoundRoomPinRepo: RoomDBProtocol, SongDBProtocol {
        static func uploadSongs(songs: [Hamorel.HamorelSong], userID: String) async throws {}
        static func downloadSongs(users: [Hamorel.UserData]) async throws -> [[Hamorel.HamorelSong]] { [[]] }
        static func isExistRoom(roomPin: String) async throws -> Bool { false }
        static func createRoom(roomPin: Int, user: Hamorel.UserData) async throws {}
        static func downloadRoomData(roomPin: String) async throws -> [Hamorel.UserData] { [] }
        static func countRoomMembers(roomPin: String) async throws -> Int { 1 }
        static func joinRoom(roomPin: String, userData: Hamorel.UserData) async throws {}
        static func fetchRoomMembers(roomPin: String, userData: Hamorel.UserData) async throws
                -> [Hamorel.UserData] { [] }
        static func pushNext(roomPin: String) async throws {}
        static func exitRoom(roomPin: String, id: String) async throws {}
        static func deleteRoom(roomPin: String) {}
    }

    @Test func foundRoomPin() async throws {
        let useCase = CreateRoomUseCase<FoundRoomPinRepo>()
        let roomPin = try await useCase.createRoom(user: UserData(id: "111", name: "test user"))
        #expect(roomPin.isEmpty == false)
        #expect(Int(roomPin) != nil)
    }
}
