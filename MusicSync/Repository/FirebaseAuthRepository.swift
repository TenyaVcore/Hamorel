//
//  FirebaseAuthRepository.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import Firebase
import SwiftUI

struct FirebaseAuthRepository {

    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func isAnonymous() -> Bool {
        return Auth.auth().currentUser?.isAnonymous ?? true
    }

    func fetchUser() -> UserData? {
        let user = Auth.auth().currentUser
        guard let user = user else { return nil }

        return UserData(id: user.uid, name: user.displayName ?? "ユーザー名未設定")
    }

    func createUser(email: String, name: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let request = result.user.createProfileChangeRequest()
        request.displayName = name
        try await request.commitChanges()
        try await result.user.sendEmailVerification()
    }

    // ゲストログインし、UserDataを返す
    @discardableResult
    func loginAsGuest() async throws -> UserData {
        let result = try await Auth.auth().signInAnonymously()
        return UserData(id: result.user.uid, name: "GuestUser")
    }

    func changeUserName(newName: String) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        try await changeRequest?.commitChanges()
    }
}
