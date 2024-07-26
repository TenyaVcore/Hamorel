//
//  HomeViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/07/27.
//

import Foundation
import MusicKit
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    let libraryModel = AppleMusicLibraryModel()

    @AppStorage("name") var name = "ゲストユーザー"

    @Published var isPresentAppleMusicAuthView = false
    @Published var appleMusicAuthStatus: MusicAuthorization.Status = MusicAuthorization.currentStatus

    init() {
        _isPresentAppleMusicAuthView = .init(initialValue: MusicAuthorization.currentStatus != .authorized)
    }
}
