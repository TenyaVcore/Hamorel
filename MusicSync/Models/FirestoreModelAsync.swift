//
//  FirestoreModelAsync.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/09.
//

import Firebase
import FirebaseFirestoreSwift
import MusicKit
import SwiftUI
import UIKit

struct FirestoreModelAsync {
    let db = Firestore.firestore()
    let uniqueId: String = UIDevice.current.identifierForVendor!.uuidString

    func createRoom(host: String) async throws -> Int {
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
        try await ref.document(String(roomPin)).setData(["nextFlag": false])
        try ref.document(String(roomPin)).collection("Member").document(uniqueId).setData(from: userData)

        return roomPin
    }

    // fire storeの1MB制限を超えないために楽曲情報を700曲ごとに分割してアップロード
    func uploadSongs(item: MusicItemCollection<Song>) throws {
        let batch = db.batch()
        var count = 1
        var startIndex = 0
        while startIndex < item.count {
            let endIndex = min(startIndex + 700, item.count)
            let subItem = item[startIndex..<endIndex]

            let userSongs = UserSongs(songs: MusicItemCollection<Song>(subItem))
            try batch.setData(from: userSongs, 
                              forDocument: db.collection("Songs").document(uniqueId).collection("Songs").document(String(count)))
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
            let userSongs = try await db.collection("Songs").document(user).collection("Songs").getDocuments()
            userSongs.documents.forEach { userSong in
                let userSongData = try? userSong.data(as: UserSongs.self)
                if let userSongData = userSongData {
                    songs.append(userSongData.songs)
                }
            }
        }
        return songs
    }


    func exitRoom(roomPin: Int) {
        db.collection("Room").document(String(roomPin)).collection("Member").document(uniqueId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed from \(roomPin)!")
            }
        }
    }
}
