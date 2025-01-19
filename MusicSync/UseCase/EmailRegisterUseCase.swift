//
//  EmailRegisterUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 1/12/R7.
//

import Foundation.NSError
import FirebaseAuth

struct EmailRegisterUseCase<Repo: AuthRepositoryProtocol> {

    /// ユーザー名、メールアドレス、パスワードのバリデーション
    ///
    ///  - Returns: エラーメッセージ
    func validateForm(name: String, email: String, password: String) -> String? {
        // name
        if name.count < 2 || name.count > 20 {
            return "ユーザー名は2文字以上20文字以下で入力してください"
        }

        // email
        if !email.contains("@") {
            return "メールアドレスを正しく入力してください"
        }

        // password
        if password.count < 8 || password.count > 20 {
            return "パスワードは8文字以上20文字以下で入力してください"
        }
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            return "パスワードは文字列と数字の両方を含めてください"
        }
        if Int(password) != nil {
            return "パスワードは文字列と数字の両方を含めてください"
        }

        return nil
    }

    func createUser(name: String, email: String, password: String) async throws {
        try await Repo.createUser(email: email, name: name, password: password)
    }

    func convertErrorToMessage(error: Error) -> String {
        if let error = error as NSError? {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .emailAlreadyInUse:
                    return "このメールアドレスは既に使用されています"
                case .weakPassword:
                    return "パスワードが脆弱です"
                case .invalidEmail:
                    return "メールアドレスの形式が不正です"
                case .userNotFound, .wrongPassword:
                    return "メールアドレスまたはパスワードが間違っています"
                case .userDisabled:
                    return "アカウントが無効です"
                default:
                    return "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
                }
            } else {
                return "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
            }
        }
    }
}
