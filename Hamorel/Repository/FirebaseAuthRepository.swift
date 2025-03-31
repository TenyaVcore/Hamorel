//
//  FirebaseAuthRepository.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/05/22.
//

import Firebase
import SwiftUI

protocol AuthRepositoryProtocol {
    static func isLoggedIn() -> Bool
    static func isAnonymous() -> Bool
    static func fetchUser() -> UserData?
    static func createUser(email: String, name: String, password: String) async throws
    @discardableResult static func loginAsGuest() async throws -> UserData
    static func changeUserName(newName: String) async throws
    static func sendPasswordReset(email: String) async throws
}

enum FirebaseAuthRepository {}

extension FirebaseAuthRepository: AuthRepositoryProtocol {

    static func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    static func isAnonymous() -> Bool {
        return Auth.auth().currentUser?.isAnonymous ?? true
    }

    static func fetchUser() -> UserData? {
        let user = Auth.auth().currentUser
        guard let user = user else { return nil }

        return UserData(id: user.uid, name: user.displayName ?? "ユーザー名未設定")
    }

    static func createUser(email: String, name: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let request = result.user.createProfileChangeRequest()
        request.displayName = name
        try await request.commitChanges()
        try await result.user.sendEmailVerification()
    }

    // ゲストログインし、UserDataを返す
    @discardableResult
    static func loginAsGuest() async throws -> UserData {
        let result = try await Auth.auth().signInAnonymously()
        return UserData(id: result.user.uid, name: "GuestUser")
    }

    static func changeUserName(newName: String) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        try await changeRequest?.commitChanges()
    }

    static func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
