//
//  EmailRegisterViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/05.
//

import SwiftUI
import Firebase

class EmailRegisterViewModel: ObservableObject {
    let authModel = FirebaseAuthModel()

    func validateForm(name: String, email: String, password: String) -> String? {
        var errorMessage: String?
        // name
        if name.count < 2 || name.count > 20 {
            errorMessage = "ユーザー名は2文字以上20文字以下で入力してください"
            return errorMessage
        }

        // email
        if !email.contains("@") {
            errorMessage = "メールアドレスを正しく入力してください"
            return errorMessage
        }

        // password
        if password.count < 8 || password.count > 20 {
            errorMessage = "パスワードは8文字以上20文字以下で入力してください"
            return errorMessage
        }
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            errorMessage = "パスワードは文字列と数字の両方を含めてください"
            return errorMessage
        }
        if Int(password) != nil {
            errorMessage = "パスワードは文字列と数字の両方を含めてください"
            return errorMessage
        }
        return errorMessage
    }

    func createUser(email: String, name: String, password: String, completion: @escaping (String?) -> Void) {
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
}
