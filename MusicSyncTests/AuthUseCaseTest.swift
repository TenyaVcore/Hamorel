//
//  AuthUseCaseTest.swift
//  MusicSyncTests
//
//  Created by 田川展也 on 1/19/R7.
//

import Testing
@testable import MusicSync

struct AuthUseCaseTest {
    struct LoggedInMockAuthRepository: AuthRepositoryProtocol {
        static func isLoggedIn() -> Bool { true }
        static func isAnonymous() -> Bool { false }

        static func fetchUser() -> MusicSync.UserData? {
            UserData(id: "111", name: "logged in user")
        }

        static func createUser(email: String, name: String, password: String) async throws {}

        static func loginAsGuest() async throws -> MusicSync.UserData {
            UserData(id: "222", name: "guest user")
        }

        static func changeUserName(newName: String) async throws {}
        static func sendPasswordReset(email: String) async throws {}
    }

    struct NotLoggedInMockAuthRepository: AuthRepositoryProtocol {
        static func isLoggedIn() -> Bool { false }
        static func isAnonymous() -> Bool { false }

        static func fetchUser() -> MusicSync.UserData? {
            nil
        }

        static func createUser(email: String, name: String, password: String) async throws {}

        static func loginAsGuest() async throws -> MusicSync.UserData {
            UserData(id: "222", name: "guest user")
        }

        static func changeUserName(newName: String) async throws {}
        static func sendPasswordReset(email: String) async throws {}
    }

    struct LoggedInTest {
        let useCase = AuthUseCase<LoggedInMockAuthRepository>()

        @Test func fetchUserTest() async throws {
            let user = try await useCase.fetchUser()
            #expect(user.id == "111")
            #expect(user.name == "logged in user")
        }

        @Test func loginAsGuestIfNotLoggedInTest() async throws {
            try await useCase.loginAsGuestIfNotLoggedIn()
        }
    }

    struct NotLoggedInTest {
        let useCase = AuthUseCase<NotLoggedInMockAuthRepository>()

        @Test func fetchUserTest() async throws {
            let user = try await useCase.fetchUser()
            #expect(user.id == "222")
            #expect(user.name == "guest user")
        }

        @Test func loginAsGuestIfNotLoggedInTest() async throws {
            try await useCase.loginAsGuestIfNotLoggedIn()
        }
    }

}
