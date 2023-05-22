//
//  MusicSyncApp.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct MusicSyncApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegete
    
    var body: some Scene {
        WindowGroup {
            TitleView()
        }
    }
}
