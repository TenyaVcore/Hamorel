//
//  FirestoreModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI
import MusicKit
import UIKit

// firestoreに保存するデータモデル
struct UserData: Identifiable, Codable {
    var id: String = UIDevice.current.identifierForVendor!.uuidString
    var name: String
}

// 楽曲情報用のモデル
struct UserSongs: Codable {
    var songs: MusicItemCollection<Song>
}

enum JoinRoomError: Error {
    case roomNotFound
    case roomIsFull
    case unknownError(Error)

    var localizedDescription: String {
        switch self {
        case .roomNotFound: return "room Pinが存在しません"
        case .roomIsFull: return "ルームが満員です"
        case .unknownError(let error): return "予期せぬエラーが発生しました。詳細: （\(error)）"
        }
    }
}

//struct FirestoreModel {
//
//    let db = Firestore.firestore()
//    let uniqueId: String = UIDevice.current.identifierForVendor!.uuidString
//
//    func createRoom(createMiss: Int, user: String) -> Int {
//        var roomPin = Int.random(in: 100000...999999)
//        let userData = UserData(name: user)
//
//        let data = db.collection("room").document(String(roomPin))
//        data.getDocument { (document, error) in
//            if let document = document, document.exists {
//                print("exist roomPin")
//                if createMiss < 11 {
//                    let result = createRoom(createMiss: createMiss + 1, user: user)
//                    roomPin = result
//                } else {
//                    print("Error : failed to create group 10 times!")
//                }
//            } else {
//                print("roomPin not exist")
//                db.collection("room").document(String(roomPin)).setData(["host user": user])
//
//                do {
//                    try db.collection("room").document(String(roomPin)).collection("insideRoom").document(uniqueId).setData(from: userData)
//                } catch {
//                    print("error writing userData error:\(error)")
//                }
//            }
//        }
//        return roomPin
//    }
//
//    func joinRoom(roomPin: Int, user: String, completion: @escaping (Result<String, joinRoomError>) -> Void) {
//
//        let data = db.collection("room").document(String(roomPin))
//        let userData = UserData(name: user)
//
//        data.getDocument { (document, error) in
//            if let document = document, document.exists {
//                print("exist roomPin")
//                do {
//                    try db.collection("room").document(String(roomPin)).collection("insideRoom").document(uniqueId).setData(from: userData)
//                    completion(.success("successfully joined room"))
//                } catch {
//                    print("error writing userData error:\(error)")
//                    completion(.failure(.otherError(error)))
//                }
//            } else {
//                print("roomPin is not exist")
//                completion(.failure(.roomPinIsNotExist))
//            }
//        }
//    }
//
//    func exitRoom(roomPin: Int) {
//        db.collection("room").document(String(roomPin)).collection("insideRoom").document(uniqueId).delete { error in
//            if let error = error {
//                print("Error removing document: \(error)")
//            } else {
//                print("Document successfully removed from \(roomPin)!")
//            }
//        }
//    }
//
//    // fire storeの1MB制限を超えないために楽曲情報を700曲ごとに分割
//    func separate(item: MusicItemCollection<Song>, roomPin: Int) {
//        var count = 1
//        var startIndex = 0
//        while startIndex < item.count {
//            let endIndex = min(startIndex + 700, item.count)
//            let subItem = item[startIndex..<endIndex]
//
//            let userSongs = UserSongs(songs: MusicItemCollection<Song>(subItem))
//            do {
//                try db.collection("room").document(String(roomPin)).collection("insideRoom").document(uniqueId).collection("songs").document(String(count)).setData(from: userSongs)
//                count += 1
//            } catch {
//                print("error writing songs error:\(error)")
//            }
//            startIndex += 700
//        }
//    }
//
//    // usersDataのそれぞれのユーザーに対してfetchUserDataを行い、[MusicItemCollection]の形に格納
//    func downloadData(roomPin: Int, usersData: [UserData], completion: @escaping (Result<[MusicItemCollection<Song>], Error>) -> Void ) {
//        let dispatchGroup = DispatchGroup()
//        let dispatchQueue = DispatchQueue(label: "queue2", attributes: .concurrent)
//        var songsCollection: [MusicItemCollection<Song>] = []
//
//        usersData.forEach { userData in
//            dispatchGroup.enter()
//            dispatchQueue.async(group: dispatchGroup) {
//                fetchUserData(roomPin: roomPin, userData: userData) { result in
//                    switch result {
//                    case .success(let songs):
//                        songsCollection.append(songs)
//
//                    case .failure(let error):
//                        print("error: \(error)")
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//            dispatchGroup.notify(queue: .main) {
//                completion(.success(songsCollection))
//            }
//        }
//    }
//
//    // ユーザーの曲情報をfireStoreからダウンロードし1つのMusicItemCollectionにまとめて返す
//    func fetchUserData(roomPin: Int, userData: UserData, completion: @escaping (Result<MusicItemCollection<Song>, Error>) -> Void) {
//        var usersSongs: MusicItemCollection<Song> = MusicItemCollection<Song>()
//        let dispatchGroup = DispatchGroup()
//        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
//        let doc = db.collection("room").document(String(roomPin)).collection("insideRoom").document(userData.id).collection("songs")
//        var count = 1
//
//        doc.count.getAggregation(source: .server) { snapshot, error in
//            if let snapshot = snapshot {
//                count = snapshot.count.intValue
//                print("count: \(count)")
//
//                for i in 1...count {
//                    dispatchGroup.enter()
//
//                    dispatchQueue.async(group: dispatchGroup) {
//                        doc.document(String(i)).getDocument(as: UserSongs.self) { result in
//                            switch result {
//                            case .success(let data):
//                                usersSongs += data.songs
//
//                            case .failure(let error):
//                                print("error: \(error)")
//                            }
//
//                            dispatchGroup.leave()
//                        }
//                    }
//                }
//
//                dispatchGroup.notify(queue: .main) {
//                    completion(.success(usersSongs))
//                }
//            } else {
//                print("count error : \(String(describing: error))")
//            }
//
//        }
//
//    }
//
//}
//
