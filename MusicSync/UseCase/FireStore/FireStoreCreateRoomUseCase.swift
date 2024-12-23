//
//  FireStoreCreateRoomUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/23/R6.
//

import UIKit.UIDevice

struct CreateRoomUseCase {
    private let repo = FirestoreRepository()

    func createRoom(hostName: String) async throws -> String {
        let uniqueId: String = await UIDevice.current.identifierForVendor!.uuidString
        let userData = UserData(id: uniqueId, name: hostName)
        let maxIter = 10
        var roomPin = 0

        for i in 0...maxIter {
            roomPin = Int.random(in: 100000...999999)
            let isExist = try await repo.isExistRoom(roomPin: roomPin)
            if isExist {
                print("find roomPin")
                break
            }
            if i == maxIter {
                print("roomPin not found")
                throw CreateRoomError.canNotFindRoomPin10Times
            }
        }

        try await repo.createRoom(roomPin: roomPin, userID: uniqueId, userData: userData)
        return String(roomPin)
    }

    func uploadSongs(songs: [MusicSyncSong]) async throws {
        let uniqueId: String = await UIDevice.current.identifierForVendor!.uuidString
        try await repo.uploadSongs(songs: songs, userID: uniqueId)
    }

}
