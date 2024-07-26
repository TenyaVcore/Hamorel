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
    var storeModel = FirestoreModel()
    var musicModel = AppleMusicLibraryModel()
    var authModel = FirebaseAuthModel()
    var db = Firestore.firestore()
    var songs = MusicItemCollection<Song>()
    
    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var nextFlag = false
    @Published var errorMessage = "ルーム参加中にエラーが発生しました。もう一度お試しください"
    @Published var roomPin = "000000"
    @State private var listener: ListenerRegistration?
    @State private var roomListener: ListenerRegistration?

    init(usersData: [UserData] = [UserData](), 
         model: FirestoreModel = FirestoreModel(),
         musicModel: AppleMusicLibraryModel = AppleMusicLibraryModel()) {
        self.usersData = usersData
        self.storeModel = model
        self.musicModel = musicModel
    }

    func addListener() {
        listener = db.collection("Room").document(roomPin).collection("Member")
            .addSnapshotListener { (querySnapshot, error) in
                guard let document = querySnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.usersData = document.map { (queryDocumentSnapshot) -> UserData in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    let id = data["id"] as? String ?? "000000"
                    return UserData(id: id, name: name)
                }
            }
        
        roomListener = db.collection("Room").document(roomPin).addSnapshotListener({ (querySnapshot, error) in
            guard let data = querySnapshot?.data() else {
                print("Error fetching document: \(error!)")
                return
            }
            self.nextFlag = data["nextFlag"] as? Bool ?? false
            if data["isEnable"] as? Bool ?? true == false {
                self.errorMessage = "ルームが解散されました"
                self.isError = true
            }
        })
    }

    func joinGroup(userName: String) {
        Task {
            do {
                if Auth.auth().currentUser == nil {
                    try await authModel.loginAsGuestAsync()
                }
                songs = try await musicModel.loadLibraryAsync(limit: 0)
                print("fetch songs")
                self.usersData = try await storeModel.joinRoom(roomPin: roomPin, userName: userName)
                print("join room")
                self.addListener()
                self.isLoading = false
            } catch JoinRoomError.roomNotFound {
                self.errorMessage = "roomPinが見つかりません"
                self.isError = true
            } catch {
                self.isError = true
            }
        }
    }

    func exitGroup() {
        storeModel.exitRoom(roomPin: roomPin)
        listener?.remove()
    }

}
