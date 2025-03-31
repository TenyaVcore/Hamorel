//
//  AuthUseCase.swift
//  Hamorel
//
//  Created by 田川展也 on 1/12/R7.
//

struct AuthUseCase<Repo: AuthRepositoryProtocol>: Sendable {
    /// ユーザー情報を取得する
    ///
    /// - Note: ログインしていない場合はゲストログインを行う
    /// - Throws: ゲストログインに失敗した場合
    /// - Returns: ユーザー情報
    func fetchUser() async throws -> UserData {
        let user = Repo.fetchUser()
        if let user {
            return user
        } else {
            return try await Repo.loginAsGuest()
        }
    }

    func loginAsGuestIfNotLoggedIn() async throws {
        let isLoggedIn = Repo.isLoggedIn()
        if !isLoggedIn {
            try await Repo.loginAsGuest()
        }
    }

    func sendPasswordReset(email: String) async throws {
        try await Repo.sendPasswordReset(email: email)
    }

}
