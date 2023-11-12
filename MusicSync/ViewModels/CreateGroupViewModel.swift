//
//  CreateGroupViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Combine
import MusicKit
import Firebase
import FirebaseFirestoreSwift

@MainActor
class CreateGroupViewModel: ObservableObject {

    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var roomPin = 000000
    @State var listener: ListenerRegistration?

    var model = FirestoreModelAsync()
    var musicModel = AppleMusicLibraryModel()
    var db = Firestore.firestore()

    var songs = MusicItemCollection<Song>()

    init(usersData: [UserData] = [UserData](),
         model: FirestoreModelAsync = FirestoreModelAsync(),
         musicModel: AppleMusicLibraryModel = AppleMusicLibraryModel()) {
        self.usersData = usersData
        self.model = model
        self.musicModel = musicModel
    }

    func addListener(roomPin: Int) {
        listener = db.collection("Room").document(String(roomPin)).collection("Member").addSnapshotListener { (querySnapshot, error) in
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
    }

    func removeListener() {
        listener?.remove()
    }

    func createGroup(userName: String) throws {
        Task {
            songs = try await musicModel.loadLibraryAsync(limit: 0)
            roomPin = try await self.model.createRoom(host: userName)
            // try self.model.uploadSongs(item: songs)
            self.addListener(roomPin: roomPin)
            self.isLoading = false
        }
    }

    func exitGroup(roomPin: Int) {
        model.exitRoom(roomPin: roomPin)
    }

}
