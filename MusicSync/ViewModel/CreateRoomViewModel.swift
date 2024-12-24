//
//  CreateRoomViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import Firebase

@MainActor
class CreateRoomViewModel: ObservableObject {
    private let loadLibraryUseCase = AppleMusicLoadLibraryUseCase()
    private let createRoomUseCase = CreateRoomUseCase()
    private let listenRoomUseCase = ListenRoomUseCase()
    private let authModel = FirebaseAuthModel()

    @Published var usersData: [UserData]
    @Published var isLoading = true
    @Published var isError = false
    @Published var roomPin = "--- ---"
    @Published var nextFlag = false

    init(usersData: [UserData] = [UserData]()) {
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

    func createGroup(userName: String) async {
        do {
            if Auth.auth().currentUser == nil {
                try await authModel.loginAsGuestAsync()
            }
            let musicSyncSongs = try await loadLibraryUseCase.loadLibrary(limit: 0)

            let uniqueID: String = UIDevice.current.identifierForVendor!.uuidString
            roomPin = try await createRoomUseCase.createRoom(id: uniqueID, hostName: userName)
            try await createRoomUseCase.uploadSongs(id: uniqueID, songs: musicSyncSongs)
            self.addListener()
            self.isLoading = false
        } catch {
            print("error:\(error.localizedDescription)")
            self.isError = true
        }
    }

    func pushNext() {
        self.nextFlag = true
        listenRoomUseCase.stopListening()
        Task {
            do {
                try await createRoomUseCase.pushNext(roomPin: roomPin)
            } catch {
                self.isError = true
            }
        }
    }

    func deleteGroup() {
        listenRoomUseCase.stopListening()
        createRoomUseCase.deleteRoom(roomPin: roomPin)
    }

    func onAppear(userName: String) async {
        let uniqueId: String = UIDevice.current.identifierForVendor!.uuidString
        await createGroup(userName: userName)
        usersData = [UserData(id: uniqueId, name: userName)]
    }
}
