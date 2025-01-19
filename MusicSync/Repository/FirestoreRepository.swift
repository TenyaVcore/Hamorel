//
//  FirestoreRepository.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/09.
//

import FirebaseFirestore

protocol RemoteDBProtocol {
    func isExistRoom(roomPin: String) async throws -> Bool
    func createRoom(roomPin: Int, user: UserData) async throws
    func uploadSongs(songs: [MusicSyncSong], userID: String) async throws
    func downloadRoomData(roomPin: String) async throws -> [UserData]
    func downloadSongs(users: [UserData]) async throws -> [[MusicSyncSong]]
    func countRoomMembers(roomPin: String) async throws -> Int
    func joinRoom(roomPin: String, userData: UserData) async throws
    func fetchRoomMembers(roomPin: String, userData: UserData) async throws -> [UserData]
    func pushNext(roomPin: String) async throws
    func exitRoom(roomPin: String, id: String) async throws
    func deleteRoom(roomPin: String)
}

struct FirestoreRepository: RemoteDBProtocol, Sendable {
    func isExistRoom(roomPin: String) async throws -> Bool {
        let db = Firestore.firestore()
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

    func createRoom(roomPin: Int, user: UserData) async throws {
        let db = Firestore.firestore()
        let ref = db.collection("Room")
        try await ref.document(String(roomPin))
            .setData(["nextFlag": false, "isEnable": true])
        try ref.document(String(roomPin)).collection("Member").document(user.id).setData(from: user)
    }

    func uploadSongs(songs: [MusicSyncSong], userID: String) async throws {
        let db = Firestore.firestore()
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
        let db = Firestore.firestore()
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
        let db = Firestore.firestore()
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

    func countRoomMembers(roomPin: String) async throws -> Int {
        let db = Firestore.firestore()
        let roomData = try await db.collection("Room").document(roomPin).collection("Member").getDocuments()
        return roomData.count
    }

    func joinRoom(roomPin: String, userData: UserData) async throws {
        let db = Firestore.firestore()
        try db.collection("Room").document(roomPin).collection("Member").document(userData.id).setData(from: userData)
    }

    func fetchRoomMembers(roomPin: String, userData: UserData) async throws -> [UserData] {
        let db = Firestore.firestore()
        let roomRef = db.collection("Room").document(roomPin)
        let roomData = try await roomRef.collection("Member").getDocuments()
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
        let db = Firestore.firestore()
        try await db.collection("Room").document(roomPin).setData(["nextFlag": true, "isEnable": true])
    }

    func exitRoom(roomPin: String, id: String) async throws {
        let db = Firestore.firestore()
        do {
            try await db.collection("Room")
                .document(roomPin)
                .collection("Member")
                .document(id)
                .delete()
            print("Document successfully removed from \(roomPin)!")
        } catch let error {
            print("Error removing document: \(error)")
            throw error
        }
    }

    func deleteRoom(roomPin: String) {
        let db = Firestore.firestore()
        db.collection("Room").document(roomPin).setData(["nextFlag": false, "isEnable": false])
    }
}
