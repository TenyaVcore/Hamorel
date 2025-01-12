//
//  AuthUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 1/12/R7.
//

struct AuthUseCase: Sendable {
    let repo = FirebaseAuthRepository()

    func fetchUser() async throws -> UserData? {
        let user = repo.fetchUser()
        return user
    }

    func loginAsGuestIfNotLoggedIn() async throws {
        let isLoggedIn = repo.isLoggedIn()
        if !isLoggedIn {
            try await repo.loginAsGuest()
        }
    }

}
