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
    private let joinRoomUseCase = JoinRoomUseCase<FirestoreRepository>()
    private var loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    private var authUseCase = AuthUseCase()

    var songs: [MusicSyncSong] = []

    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var nextFlag = false
    @Published var errorMessage = "ルーム参加中にエラーが発生しました。もう一度お試しください"
    @Published var roomPin: String

    init(usersData: [UserData] = [UserData](),
         roomPin: String
    ) {
        self.usersData = usersData
        self.roomPin = roomPin
    }

    func onAppear() async {
        do {
            try await authUseCase.loginAsGuestIfNotLoggedIn()
            let userData = try await authUseCase.fetchUser()
            joinGroup(userData: userData)
            if !nextFlag {
                await exitGroup()
            }
        } catch {
            self.isError = true
        }
    }

    func onTappedExitButton() {
        Task {
            await exitGroup()
        }
    }

    private func addListener() {
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

    private func joinGroup(userData: UserData) {
        Task {
            do {
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

    private func exitGroup() async {
        do {
            listenRoomUseCase.stopListening()
            let user = try await authUseCase.fetchUser()
            try await joinRoomUseCase.exitRoom(roomPin: roomPin, userData: user)
        } catch {
            // 何もしない
        }
    }
}
