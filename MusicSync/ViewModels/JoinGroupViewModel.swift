//
//  JoinGroupViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit
import Firebase
import FirebaseFirestoreSwift

@MainActor
class JoinGroupViewModel: ObservableObject {
    var storeModel = FirestoreModelAsync()
    var musicModel = AppleMusicLibraryModel()
    var authModel = FirebaseAuthModel()
    var db = Firestore.firestore()
    var songs = MusicItemCollection<Song>()
    
    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var errorMessage = "ルーム参加中にエラーが発生しました。もう一度お試しください"
    @Published var roomPin = 000000
    @State private var listener: ListenerRegistration?

    init(usersData: [UserData] = [UserData](), 
         model: FirestoreModelAsync = FirestoreModelAsync(),
         musicModel: AppleMusicLibraryModel = AppleMusicLibraryModel()) {
        self.usersData = usersData
        self.storeModel = model
        self.musicModel = musicModel
    }

    func addListener(roomPin: String, completion: @escaping (Result<String, Error>) -> Void) {
        listener = db.collection("Room").document(roomPin).collection("Member")
            .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                self.usersData = (querySnapshot?.documents.map { (queryDocumentSnapshot) -> UserData in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    let id = data["id"] as? String ?? "000000"
                    return UserData(id: id, name: name)
                })!
            }
        }
        completion(.success("success"))
    }

    func joinGroup(roomPin: String, userName: String) {
        Task {
            do {
                if Auth.auth().currentUser == nil {
                    try await authModel.loginAsGuestAsync()
                }
                songs = try await musicModel.loadLibraryAsync(limit: 0)
                print("fetch songs")
                try await storeModel.joinRoom(roomPin: roomPin, userName: userName)
                print("join room")
                self.addListener(roomPin: roomPin) { result in
                    switch result {
                    case .success:
                        self.isLoading = false
                    case .failure:
                        self.isError = true
                    }
                }
            } catch JoinRoomError.roomNotFound {
                self.errorMessage = "roomPinが見つかりません"
                self.isError = true
            } catch {
                self.isError = true
            }
        }
    }
    
//    func joinGroup(roomPin: Int, user: String) -> ListenerRegistration? {
//        var listener: ListenerRegistration?
//
//        musicModel.loadLibrary { [weak self] result in
//            switch result {
//            case .success(let songs):
//                self?.storeModel.joinRoom(roomPin: roomPin, user: user) { joinRoomResult in
//                    switch joinRoomResult {
//                    case .success:
//                        self?.storeModel.separate(item: songs, roomPin: roomPin)
//                        listener = self?.addListener(roomPin: roomPin)
//                    case .failure(let joinError):
//                        print("部屋がありません")
//                        self?.errorMessage = joinError.localizedDescription
//                        self?.isShowingAlert = true
//
//                    }
//                }
//
//            case .failure(let error):
//                self?.errorMessage = error.localizedDescription
//                self?.isShowingAlert = true
//            }
//        }
//        return listener
//    }

    func exitGroup(roomPin: Int) {
        storeModel.exitRoom(roomPin: roomPin)
    }

}
