//
//  HomeViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/07/27.
//

import MusicKit
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @AppStorage("name") var name = "ゲストユーザー"
    @Published var isPresentAppleMusicAuthView = false

    init() {
        Task {
            await _ = MusicAuthorization.request()
            await checkAppleMusicAuthStatus()
        }
    }

    func onAppear() async {
        await checkAppleMusicAuthStatus()
    }

    private func checkAppleMusicAuthStatus() async {
        let status = MusicAuthorization.currentStatus
        isPresentAppleMusicAuthView = status != .authorized
    }
}
