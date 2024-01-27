//
//  FirestoreModelAsync.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/09.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MusicKit
import SwiftUI
import UIKit

struct FirestoreModelAsync {
    let db = Firestore.firestore()
    let uniqueId: String = UIDevice.current.identifierForVendor!.uuidString

    func createRoom(host: String) async throws -> String {
        let userData = UserData(name: host)
        var failCount: Int = 0
        var roomPin = Int.random(in: 100000...999999)
        let ref = db.collection("Room")

        // すでに存在していないroomPinを探索
        while true {
            do {
                try await ref.document(String(roomPin)).getDocument()
                print("find roomPin")
                break
            } catch {
                roomPin = Int.random(in: 100000...999999)
                failCount += 1
                if failCount > 10 {
                    print("can not find roomPin")
                    throw CreateRoomError.canNotFindRoomPin10Times
                }
            }
        }
        try await ref.document(String(roomPin))
            .setData(["nextFlag": false, "isEnable": true])
        try ref.document(String(roomPin)).collection("Member").document(uniqueId).setData(from: userData)

        return String(roomPin)
    }

    // fire storeの1MB制限を超えないために楽曲情報を700曲ごとに分割してアップロード
    func uploadSongs(item: MusicItemCollection<Song>) throws {
        let ref = db.collection("Songs").document(uniqueId).collection("Songs")
        let batch = db.batch()
        var count = 1
        var startIndex = 0
        while startIndex < item.count {
            let endIndex = min(startIndex + 700, item.count)
            let subItem = item[startIndex..<endIndex]

            let userSongs = UserSongs(songs: MusicItemCollection<Song>(subItem))
            try batch.setData(from: userSongs, 
                              forDocument: ref.document(String(count)))
            count += 1
            startIndex += 700
        }
        batch.commit()
    }

    func downloadRoomData(roomPin: String) async throws -> [String] {
        var users: [String] = []
        let members =  try await db.collection("Room").document(roomPin).collection("Member").getDocuments()
        members.documents.forEach { member in
            users.append(member.documentID)
        }
        return users
    }
    
    func downloadSongs(users: [String]) async throws -> [MusicItemCollection<Song>] {
        var songs: [MusicItemCollection<Song>] = []
        for user in users {
            var userSongs = MusicItemCollection<Song>()
            let userSongsSnapshot = try await db.collection("Songs").document(user).collection("Songs").getDocuments()
            userSongsSnapshot.documents.forEach { userSong in
                let userSongData = try? userSong.data(as: UserSongs.self)
                if let userSongData = userSongData {
                    userSongs += userSongData.songs
                }
            }
            songs.append(userSongs)
        }
        return songs
    }
    
    func joinRoom(roomPin: String, userName: String) async throws -> [UserData] {
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

        let userData = UserData(name: userName)
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

    func exitRoom(roomPin: String) {
        db.collection("Room").document(roomPin).collection("Member").document(uniqueId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed from \(roomPin)!")
            }
        }
    }

    func deleteRoom(roomPin: String) {
        db.collection("Room").document(roomPin).setData(["nextFlag": false, "isEnable": false])
    }
}
