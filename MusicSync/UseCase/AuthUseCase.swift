//
//  AuthUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 1/12/R7.
//

struct AuthUseCase: Sendable {
    let repo = FirebaseAuthRepository()

    /// ユーザー情報を取得する
    ///
    /// - Note: ログインしていない場合はゲストログインを行う
    /// - Throws: ゲストログインに失敗した場合
    /// - Returns: ユーザー情報
    func fetchUser() async throws -> UserData {
        let user = repo.fetchUser()
        if let user {
            return user
        } else {
            return try await repo.loginAsGuest()
        }
    }

    func loginAsGuestIfNotLoggedIn() async throws {
        let isLoggedIn = repo.isLoggedIn()
        if !isLoggedIn {
            try await repo.loginAsGuest()
        }
    }

}
