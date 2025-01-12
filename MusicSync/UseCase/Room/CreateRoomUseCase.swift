//
//  CreateRoomUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/23/R6.
//

struct CreateRoomUseCase: Sendable {
    private let repo = FirestoreRepository()

    func createRoom(user: UserData) async throws -> String {
        let maxIter = 10
        var roomPin = 0

        for i in 0...maxIter {
            roomPin = Int.random(in: 100000...999999)
            let isExist = try await repo.isExistRoom(roomPin: String(roomPin))
            if !isExist {
                print("find roomPin")
                break
            }
            if i == maxIter {
                print("roomPin not found")
                throw CreateRoomError.canNotFindRoomPin10Times
            }
        }

        try await repo
            .createRoom(roomPin: roomPin, userID: user.id, user: user)
        return String(roomPin)
    }

    func uploadSongs(user: UserData, songs: [MusicSyncSong]) async throws {
        try await repo.uploadSongs(songs: songs, userID: user.id)
    }

    func pushNext(roomPin: String) async throws {
        try await repo.pushNext(roomPin: roomPin)
    }

    func deleteRoom(roomPin: String) {
        repo.deleteRoom(roomPin: roomPin)
    }
}
