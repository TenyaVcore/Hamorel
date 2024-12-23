//
//  ListenRoomUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/24/R6.
//

import Observation
import FirebaseFirestore

final class ListenRoomUseCase {
    var listener: ListenerRegistration?

    /// ドキュメントの変更を監視
       /// - Parameters:
       ///   - roomPin: ルームピン
       ///   - completion: 変更が通知されたときのコールバック
       func listenRoom(
           roomPin: String,
           completion: @escaping (Result<[[String: Any]], Error>) -> Void
       ) {
           let db = Firestore.firestore()
           let documentRef = db.collection("Room").document(roomPin).collection("Member")

           // リスナーを追加
           listener = documentRef.addSnapshotListener { documentSnapshot, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               if let documentSnapshot = documentSnapshot {
                   let data = documentSnapshot.documents.map { $0.data() }
                   completion(.success(data))
               }
           }
       }

       /// リスナーを解除
       func stopListening() {
           listener?.remove()
           listener = nil
       }
}
