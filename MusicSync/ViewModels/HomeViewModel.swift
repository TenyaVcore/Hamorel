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
    init(appleMusicAuthStatus: MusicAuthorization.Status = MusicAuthorization.currentStatus) {
        _isPresentAppleMusicAuthView = .init(initialValue: appleMusicAuthStatus != .authorized)
    }

    @AppStorage("name") var name = "ゲストユーザー"
    @Published var isPresentAppleMusicAuthView = false

}
