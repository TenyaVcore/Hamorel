//
//  ListenRoomUseCase.swift
//  Hamorel
//
//  Created by 田川展也 on 12/24/R6.
//

import Observation
import FirebaseFirestore

final class ListenRoomUseCase {
    var memberListener: ListenerRegistration?
    var roomListener: ListenerRegistration?
    /// ドキュメントの変更を監視
       /// - Parameters:
       ///   - roomPin: ルームピン
       ///   - completion: 変更が通知されたときのコールバック
       func listenMember(
           roomPin: String,
           completion: @escaping (Result<[UserData], Error>) -> Void
       ) {
           let db = Firestore.firestore()
           let documentRef = db.collection("Room").document(roomPin).collection("Member")

           // リスナーを追加
           memberListener = documentRef.addSnapshotListener { querySnapshot, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               // データをUserDataに変換
               if let querySnapshot {
                   let data = querySnapshot.documents.map { $0.data() }
                   let userData = data.map { data -> UserData in
                       let name = data["name"] as? String ?? ""
                       let id = data["id"] as? String ?? "000000"
                       return UserData(id: id, name: name)
                   }
                   completion(.success(userData))
               } else {
                   completion(.failure(NSError(domain: "ListenRoomUseCase", code: 0, userInfo: nil)))
               }
           }
       }

    func listenRoom(
        roomPin: String,
        completion: @escaping (Result<(Bool, Bool), Error>) -> Void
    ) {
        let db = Firestore.firestore()
        let documentRef = db.collection("Room").document(roomPin)

        // リスナーを追加
        roomListener = documentRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = documentSnapshot?.data() {
                let nextFlag = data["nextFlag"] as? Bool ?? false
                let isEnable = data["isEnable"] as? Bool ?? false
                completion(.success((nextFlag, isEnable)))
            } else {
                completion(.failure(NSError(domain: "ListenRoomUseCase", code: 0, userInfo: nil)))
            }
        }
    }

       /// リスナーを解除
       func stopListening() {
           memberListener?.remove()
           roomListener?.remove()
           memberListener = nil
           roomListener = nil
       }
}
