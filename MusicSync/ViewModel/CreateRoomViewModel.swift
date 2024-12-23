//
//  CreateRoomViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestoreSwift

@MainActor
class CreateRoomViewModel: ObservableObject {
    private let loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    private let createRoomUseCase = CreateRoomUseCase()
    private let authModel = FirebaseAuthModel()
    private let db = Firestore.firestore()

    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var roomPin = "--- ---"
    @Published var nextFlag = false
    @State private var listener: ListenerRegistration?

    init(usersData: [UserData] = [UserData]()) {
        self.usersData = usersData
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
    }

    func removeListener() {
        listener?.remove()
    }

    func createGroup(userName: String) async {
        do {
            if Auth.auth().currentUser == nil {
                try await authModel.loginAsGuestAsync()
            }
            let musicSyncSongs = try await loadLibraryUseCase.loadLibrary(limit: 0)

            roomPin = try await createRoomUseCase.createRoom(hostName: userName)
            try await createRoomUseCase.uploadSongs(songs: musicSyncSongs)
            self.addListener()
            self.isLoading = false
        } catch {
            print("error:\(error.localizedDescription)")
            self.isError = true
        }
    }
    
    func pushNext() {
        let storeModel = FirestoreRepository()
        self.nextFlag = true
        self.listener?.remove()
        Task {
            do {
                try await storeModel.pushNext(roomPin: roomPin)
            } catch {
                self.isError = true
            }
        }
    }

    func deleteGroup() {
        let storeModel = FirestoreRepository()
        self.listener?.remove()
        storeModel.deleteRoom(roomPin: roomPin)
    }

    func onAppear(userName: String) async {
        let uniqueId: String = UIDevice.current.identifierForVendor!.uuidString
        await createGroup(userName: userName)
        usersData = [UserData(id: uniqueId, name: userName)]
    }

}
