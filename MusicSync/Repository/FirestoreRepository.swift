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

    func isExistRoom(roomPin: Int) async throws -> Bool {
        let document = try await db.collection("Room").document(String(roomPin)).getDocument()
        return document.exists
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

    func joinRoom(roomPin: String, userName: String) async throws -> [UserData] {
        let uniqueId: String = await UIDevice.current.identifierForVendor!.uuidString
        let roomRef = db.collection("Room").document(roomPin)
        var usersData = [UserData]()

        guard let data = try await roomRef.getDocument().data(),
              let isEnable = data["isEnable"] as? Bool,
              let nextFlag = data["nextFlag"] as? Bool,
                isEnable, !nextFlag
            else {
            throw JoinRoomError.roomNotFound
        }

        let roomData = try await roomRef.collection("Member").getDocuments()
        if roomData.count > 4 {
            throw JoinRoomError.roomIsFull
        }

        let userData = UserData(id: uniqueId, name: userName)
        try db.collection("Room").document(roomPin).collection("Member").document(uniqueId).setData(from: userData)

        usersData = roomData.documents.map { (queryDocumentSnapshot) -> UserData in
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
