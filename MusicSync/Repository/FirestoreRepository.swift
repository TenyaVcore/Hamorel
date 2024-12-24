//
//  FirestoreRepository.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/09.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreRepository: @unchecked Sendable {
    let db = Firestore.firestore()

    func isExistRoom(roomPin: String) async throws -> Bool {
        let document = try await db.collection("Room").document(roomPin).getDocument()
        // documentが存在しない場合はfalseを返す
        if !document.exists { return false }
        let data = document.data()
        // isEnable(部屋が有効)がtrueかつnextFlag(部屋の確定)がfalseの場合はtrueを返す
        guard let isEnable = data?["isEnable"] as? Bool,
              let nextFlag = data?["nextFlag"] as? Bool,
              isEnable,
              !nextFlag
        else { return false }

        return true
    }

    func createRoom(roomPin: Int, userID: String, userData: UserData) async throws {
        let ref = db.collection("Room")
        try await ref.document(String(roomPin))
            .setData(["nextFlag": false, "isEnable": true])
        try ref.document(String(roomPin)).collection("Member").document(userID).setData(from: userData)
    }

    func uploadSongs(songs: [MusicSyncSong], userID: String) async throws {
        let batchSize = 3000
        let ref = db.collection("Songs").document(userID).collection("Songs")
        let batch = db.batch()
        var count = 1
        var startIndex = 0

        while startIndex < songs.count {
            let endIndex = min(startIndex + batchSize, songs.count)
            let separatedItem: [MusicSyncSong] = Array(songs[startIndex..<endIndex])

            try batch.setData(from: separatedItem,
                              forDocument: ref.document(String(count)))
            count += 1
            startIndex += batchSize
        }
        try await batch.commit()
    }

    func downloadRoomData(roomPin: String) async throws -> [UserData] {
        var users: [UserData] = []
        let members =  try await db.collection("Room").document(roomPin).collection("Member").getDocuments()
        members.documents.forEach { member in
            do {
                let data = try member.data(as: UserData.self)
                users.append(data)
            } catch {
                print(error)
            }

        }
        return users
    }

    func downloadSongs(users: [UserData]) async throws -> [[MusicSyncSong]] {
        var songs: [[MusicSyncSong]] = []
        for user in users {
            var userSongs = [MusicSyncSong]()
            let userSongsSnapshot = try await db.collection("Songs").document(user.id)
                                                .collection("Songs").getDocuments()
            userSongsSnapshot.documents.forEach { userSong in
                if let userSongData = try? userSong.data(as: [MusicSyncSong].self) {
                    userSongs += userSongData
                }
            }
            songs.append(userSongs)
        }
        return songs
    }

    func joinRoom(roomPin: String, userData: UserData) async throws -> [UserData] {
        let roomRef = db.collection("Room").document(roomPin)
        let isExistRoom = try await isExistRoom(roomPin: roomPin)
        if  !isExistRoom { throw JoinRoomError.roomNotFound }

        let roomData = try await roomRef.collection("Member").getDocuments()
        if roomData.count > 4 {
            throw JoinRoomError.roomIsFull
        }

        try db.collection("Room").document(roomPin).collection("Member").document(userData.id).setData(from: userData)

        var usersData = roomData.documents.map { (queryDocumentSnapshot) -> UserData in
            let data = queryDocumentSnapshot.data()
            let name = data["name"] as? String ?? ""
            let id = data["id"] as? String ?? "000000"
            return UserData(id: id, name: name)
        }
        usersData.append(userData)

        return usersData
    }

    func pushNext(roomPin: String) async throws {
        try await db.collection("Room").document(roomPin).setData(["nextFlag": true, "isEnable": true])
    }

    func exitRoom(roomPin: String) async throws {
        let uniqueId: String = await UIDevice.current.identifierForVendor!.uuidString

        do {

            try await db.collection("Room")
                .document(roomPin)
                .collection("Member")
                .document(uniqueId)
                .delete()
            print("Document successfully removed from \(roomPin)!")
        } catch let error {
            print("Error removing document: \(error)")
            throw error
        }
    }

    func deleteRoom(roomPin: String) {
        db.collection("Room").document(roomPin).setData(["nextFlag": false, "isEnable": false])
    }
}
