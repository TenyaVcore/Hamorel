//
//  CreateRoomViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import Firebase
import SwiftUICore

@MainActor
class CreateRoomViewModel: ObservableObject {
    private let loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    private let createRoomUseCase = CreateRoomUseCase()
    private let listenRoomUseCase = ListenRoomUseCase()
    private let authModel = FirebaseAuthModel()

    @Published var usersData: [UserData] = []
    @Published var isLoading = true
    @Published var isError = false
    @Published var roomPin = "--- ---"
    @Published var nextFlag = false

    init(usersData: [UserData]) {
        self.usersData = usersData
    }

    func addListener() {
        listenRoomUseCase.listenMember(roomPin: roomPin) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.usersData = data
            case .failure(let error):
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
        }
    }

    func createGroup(user: UserData) async {
        do {
            if Auth.auth().currentUser == nil {
                try await authModel.loginAsGuestAsync()
            }
            let musicSyncSongs = try await loadLibraryUseCase.loadLibrary(limit: 0)

            roomPin = try await createRoomUseCase
                .createRoom(user: user)
            try await createRoomUseCase
                .uploadSongs(user: user, songs: musicSyncSongs)
            self.addListener()
            self.isLoading = false
        } catch {
            print("error:\(error.localizedDescription)")
            self.isError = true
        }
    }

    func onTappedNextButton() async -> Bool {
        self.nextFlag = true
        listenRoomUseCase.stopListening()
        do {
            try await createRoomUseCase.pushNext(roomPin: roomPin)
            return true
        } catch {
            self.isError = true
            return false
        }
    }

    func deleteGroup() {
        listenRoomUseCase.stopListening()
        createRoomUseCase.deleteRoom(roomPin: roomPin)
    }

    func onAppear() async {
        let user = StoreUserUseCase.shared.fetchUser()
        await createGroup(user: user)
        usersData = [user]
    }

    func onDisappear() {
        if !nextFlag {
            deleteGroup()
        }
    }
}
