//
//  ListenRoomUseCase.swift
//  MusicSync
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
           completion: @escaping (Result<[[String: Any]], Error>) -> Void
       ) {
           let db = Firestore.firestore()
           let documentRef = db.collection("Room").document(roomPin).collection("Member")

           // リスナーを追加
           memberListener = documentRef.addSnapshotListener { querySnapshot, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               if let querySnapshot {
                   let data = querySnapshot.documents.map { $0.data() }
                   completion(.success(data))
               } else {
                   completion(.failure(NSError(domain: "ListenRoomUseCase", code: 0, userInfo: nil)))
               }
           }
       }

    func listenRoom(
        roomPin: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
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
                completion(.success(data))
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
