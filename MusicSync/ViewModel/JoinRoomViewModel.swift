//
//  JoinGroupViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@MainActor
class JoinRoomViewModel: ObservableObject {
    var storeModel = FirestoreRepository()
    private let listenRoomUseCase = ListenRoomUseCase()
    var loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    var authModel = FirebaseAuthModel()
    var db = Firestore.firestore()
    var songs: [MusicSyncSong] = []

    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var nextFlag = false
    @Published var errorMessage = "ルーム参加中にエラーが発生しました。もう一度お試しください"
    @Published var roomPin = "000000"
    @State private var listener: ListenerRegistration?
    @State private var roomListener: ListenerRegistration?

    init(usersData: [UserData] = [UserData](),
         model: FirestoreRepository = FirestoreRepository()) {
        self.usersData = usersData
        self.storeModel = model
    }

    func addListener() {
        listenRoomUseCase.listenMember(roomPin: roomPin) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.usersData = data.map { data -> UserData in
                    let name = data["name"] as? String ?? ""
                    let id = data["id"] as? String ?? "000000"
                    return UserData(id: id, name: name)
                }
            case .failure(let error):
                print("Error fetching document: \(error)")
                return
            }
        }

        listenRoomUseCase.listenRoom(roomPin: roomPin) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.nextFlag = data["nextFlag"] as? Bool ?? false
                if data["isEnable"] as? Bool ?? true == false {
                    self.errorMessage = "ルームが解散されました"
                    self.isError = true
                }
            case .failure(let error):
                print("Error fetching document: \(error)")
                return
            }
        }
    }

    func joinGroup(userName: String) {
        Task {
            do {
                if Auth.auth().currentUser == nil {
                    try await authModel.loginAsGuestAsync()
                }
                songs = try await loadLibraryUseCase.loadLibrary(limit: 0)
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

    func exitGroup() async throws {
        try await storeModel.exitRoom(roomPin: roomPin)
        listener?.remove()
    }
}
