//
//  JoinGroupViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

@MainActor
class JoinRoomViewModel: ObservableObject {
    private let listenRoomUseCase = ListenRoomUseCase()
    private let joinRoomUseCase = JoinRoomUseCase()
    private var loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    var authModel = FirebaseAuthModel()

    var songs: [MusicSyncSong] = []

    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var nextFlag = false
    @Published var errorMessage = "ルーム参加中にエラーが発生しました。もう一度お試しください"
    @Published var roomPin = "000000"

    init(usersData: [UserData] = [UserData](),
         model: FirestoreRepository = FirestoreRepository()) {
        self.usersData = usersData
    }

    func addListener() {
        listenRoomUseCase.listenMember(roomPin: roomPin) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.usersData = data
            case .failure(let error):
                print("Error fetching document: \(error)")
            }
        }

        listenRoomUseCase.listenRoom(roomPin: roomPin) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.nextFlag = data.0
                let isEnable = data.1
                if isEnable == false {
                    self.errorMessage = "ルームが解散されました"
                    self.isError = true
                }
            case .failure(let error):
                print("Error fetching document: \(error)")
            }
        }
    }

    func joinGroup(userData: UserData) {
        Task {
            do {
                if Auth.auth().currentUser == nil {
                    try await authModel.loginAsGuestAsync()
                }
                songs = try await loadLibraryUseCase.loadLibrary(limit: 0)
                print("fetch songs")
                self.usersData = try await joinRoomUseCase
                    .joinRoom(roomPin: roomPin, userData: userData)
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
        // FIXME: userData[0]ではない
        try await joinRoomUseCase.exitRoom(roomPin: roomPin, userData: usersData[0])
        listenRoomUseCase.stopListening()
    }
}
