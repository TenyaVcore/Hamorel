//
//  JoinRoomUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/25/R6.
//

struct JoinRoomUseCase<Repo: RoomDBProtocol> {

    func joinRoom(roomPin: String, userData: UserData) async throws -> [UserData] {
        // 部屋が入室可能か確認
        let isExistRoom = try await Repo.isExistRoom(roomPin: roomPin)
        if  !isExistRoom { throw JoinRoomError.roomNotFound }

        // 部屋が満員か確認
        let memberCount = try await Repo.countRoomMembers(roomPin: roomPin)
        if memberCount > 4 { throw JoinRoomError.roomIsFull }

        do {
            try await Repo.joinRoom(roomPin: roomPin, userData: userData)
        } catch {
            throw JoinRoomError.failedToJoinRoom
        }
        let result = try await Repo.fetchRoomMembers(roomPin: roomPin, userData: userData)
        return result
    }

    func exitRoom(roomPin: String, userData: UserData) async throws {
        try await Repo.exitRoom(roomPin: roomPin, id: userData.id)
    }
}
