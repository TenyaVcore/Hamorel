//
//  Router.swift
//  MusicSync
//
//  Created by 田川展也 on 12/25/R6.
//

import SwiftUI

@MainActor
final class Router: ObservableObject {
    @Published var path: [NavigationLinkItem] = []

    func navigate(item: NavigationLinkItem) -> some View {
        Group {
            switch item {
            case .create:
                CreateRoomView()
            case .enter:
                EnterRoomPinView()
            case .join(let roomPin):
                JoinRoomView(roomPin: roomPin)
            case .playlist(let roomPin):
                CreatePlaylistView(roomPin: roomPin)
            case .home:
                HomeView()
            case .setting:
                SettingView()
            case .login:
                LogInView()
            case .passwordReset:
                PasswordResetView()
            case .register:
                EmailRegisterView()
            case .provision:
                ProvisionalRegistrationView()
            case .license:
                LicenseView()
            case .debug:
                DebugView()
            }
        }
    }

    func push(_ item: NavigationLinkItem) {
        path.append(item)
    }

    func pop() {
        if path.count > 1 {
            path.removeLast()
        }
    }

    func popToRoot() {
        path.removeAll()
    }
}
