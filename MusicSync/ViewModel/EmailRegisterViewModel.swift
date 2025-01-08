//
//  EmailRegisterViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/05.
//

import SwiftUI
import Firebase

@MainActor
class EmailRegisterViewModel: ObservableObject {
    private let authModel = FirebaseAuthModel()

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage = ""

    func onTappedRegisterButton(completion: @escaping (Bool) -> Void) {
        createUser(email: email, name: name, password: password) { [weak self] error in
            guard let self else { return }
            if let error = error {
                errorMessage = error
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    private func createUser(email: String, name: String, password: String, completion: @escaping (String?) -> Void) {
        let errorMessage = validateForm(name: name, email: email, password: password)
        if let errorMessage = errorMessage {
            completion(errorMessage)
            return
        }

        authModel.createUser(email: email, name: name, password: password) { error in
            if let error = error as NSError? {
                var errorMessage = ""
                if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                    switch errorCode {
                    case .invalidEmail:
                        errorMessage = "メールアドレスの形式が違います。"
                    case .emailAlreadyInUse:
                        errorMessage = "このメールアドレスはすでに使用されています。"
                    case .weakPassword:
                        errorMessage = "パスワードが脆弱です。"
                    case .userNotFound, .wrongPassword:
                        errorMessage = "メールアドレス、またはパスワードが間違っています"
                    case .userDisabled:
                        errorMessage = "このユーザーアカウントは無効化されています"
                    default:
                        errorMessage = "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
                    }
                }
                completion(errorMessage)
            } else {
                completion(nil)
            }
        }
    }

    private func validateForm(name: String, email: String, password: String) -> String? {
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
}
