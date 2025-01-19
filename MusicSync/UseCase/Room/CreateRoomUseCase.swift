//
//  CreateRoomUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/23/R6.
//

struct CreateRoomUseCase<Repo: RemoteDBProtocol>: Sendable {

    func createRoom(user: UserData) async throws -> String {
        let maxIter = 10
        var roomPin = 0

        for i in 0...maxIter {
            roomPin = Int.random(in: 100000...999999)
            let isExist = try await Repo.isExistRoom(roomPin: String(roomPin))
            if !isExist {
                print("find roomPin")
                break
            }
            if i == maxIter {
                print("roomPin not found")
                throw CreateRoomError.canNotFindRoomPin10Times
            }
        }

        try await Repo.createRoom(roomPin: roomPin, user: user)
        return String(roomPin)
    }

    func uploadSongs(user: UserData, songs: [MusicSyncSong]) async throws {
        try await Repo.uploadSongs(songs: songs, userID: user.id)
    }

    func pushNext(roomPin: String) async throws {
        try await Repo.pushNext(roomPin: roomPin)
    }

    func deleteRoom(roomPin: String) {
        Repo.deleteRoom(roomPin: roomPin)
    }
}
