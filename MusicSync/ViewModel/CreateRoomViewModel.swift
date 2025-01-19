//
//  CreateRoomViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUICore

@MainActor
class CreateRoomViewModel: ObservableObject {
    private let loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    private let createRoomUseCase = CreateRoomUseCase<FirestoreRepository>()
    private let listenRoomUseCase = ListenRoomUseCase()
    private let authUseCase = AuthUseCase()

    @Published var usersData: [UserData] = []
    @Published var isLoading = true
    @Published var isError = false
    @Published var roomPin = "--- ---"
    @Published var nextFlag = false

    func onAppear() async {
        do {
            let user = try await authUseCase.fetchUser()
            usersData = [user]
            await createGroup(user: user)
        } catch {
            self.isError = true
        }
    }

    func onDisappear() {
        if !nextFlag {
            deleteGroup()
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

    private func createGroup(user: UserData) async {
        do {
            try await authUseCase.loginAsGuestIfNotLoggedIn()
            async let musicSyncSongs = try loadLibraryUseCase.loadLibrary(limit: 0)
            async let createdRoomPin = createRoomUseCase.createRoom(user: user)
            try await createRoomUseCase.uploadSongs(user: user, songs: musicSyncSongs)
            self.roomPin = try await createdRoomPin
            self.addListener()
            self.isLoading = false
        } catch {
            print("error:\(error.localizedDescription)")
            self.isError = true
        }
    }

    private func addListener() {
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
}
