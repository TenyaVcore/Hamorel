//
//  JoinRoomUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/25/R6.
//

struct JoinRoomUseCase {
    let repo = FirestoreRepository()

    func joinRoom(roomPin: String, userData: UserData) async throws -> [UserData] {
        // 部屋が入室可能か確認
        let isExistRoom = try await repo.isExistRoom(roomPin: roomPin)
        if  !isExistRoom { throw JoinRoomError.roomNotFound }

        // 部屋が満員か確認
        let memberCount = try await repo.countRoomMembers(roomPin: roomPin)
        if memberCount > 4 { throw JoinRoomError.roomIsFull }

        do {
            try await repo.joinRoom(roomPin: roomPin, userData: userData)
        } catch {
            throw JoinRoomError.failedToJoinRoom
        }
        let result = try await repo.fetchRoomMembers(roomPin: roomPin, userData: userData)
        return result
    }

    func exitRoom(roomPin: String, userData: UserData) async throws {
        try await repo.exitRoom(roomPin: roomPin, id: userData.id)
    }
}
