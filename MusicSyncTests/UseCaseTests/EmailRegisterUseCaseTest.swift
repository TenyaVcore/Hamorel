//
//  EmailRegisterUseCaseTest.swift
//  MusicSyncTests
//
//  Created by 田川展也 on 1/19/R7.
//

import Testing
@testable import MusicSync

struct EmailRegisterUseCaseTest {

    struct MockAuthRepository: AuthRepositoryProtocol {
        static func isLoggedIn() -> Bool { true }
        static func isAnonymous() -> Bool { false }
        static func fetchUser() -> MusicSync.UserData? { nil }
        static func createUser(email: String, name: String, password: String) async throws {}
        static func loginAsGuest() async throws -> MusicSync.UserData {
            UserData(id: "1", name: "mock")
        }
        static func changeUserName(newName: String) async throws {}
        static func sendPasswordReset(email: String) async throws {}
    }

    struct ValidateFormTest {
        let useCase = EmailRegisterUseCase<MockAuthRepository>()
        @Test func shortName() {
            let result = useCase.validateForm(name: "a", email: "test@gmail.com", password: "Password12")
            #expect(result == "ユーザー名は2文字以上20文字以下で入力してください")
        }

        @Test func longName() {
            let result = useCase.validateForm(name: "abcdefghijklmnopqrstuvwxyz1234567890",
                                              email: "test@gmail.com",
                                              password: "Password12")
            #expect(result == "ユーザー名は2文字以上20文字以下で入力してください")
        }

        @Test func wrongEmail() {
            let result = useCase.validateForm(name: "name", email: "test", password: "Password12")
            #expect(result == "メールアドレスを正しく入力してください")
        }

        @Test func shortPassword() {
            let result = useCase.validateForm(name: "name", email: "test@gmail.com", password: "Pass")
            #expect(result == "パスワードは8文字以上20文字以下で入力してください")
        }

        @Test func longPassword() {
            let result = useCase.validateForm(name: "name",
                                              email: "test@gmail.com",
                                              password: "Password12345678901234567890")
            #expect(result == "パスワードは8文字以上20文字以下で入力してください")
        }

        @Test func charachterPassword() {
            let result = useCase.validateForm(name: "name",
                                              email: "test@gmail.com",
                                              password: "PasswordPassword")
            #expect(result == "パスワードは文字列と数字の両方を含めてください")
        }

        @Test func numberPassword() {
            let result = useCase.validateForm(name: "name", email: "test@gmail.com", password: "123456789012345")
            #expect(result == "パスワードは文字列と数字の両方を含めてください")
        }

        @Test func goodPassword() {
            let result = useCase.validateForm(name: "name", email: "test@gmail.com", password: "Password4567890")
            #expect(result == nil)
        }
    }

}
