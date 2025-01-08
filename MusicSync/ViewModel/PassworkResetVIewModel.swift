//
//  PassworkResetVIewModel.swift
//  MusicSync
//
//  Created by 田川展也 on 12/26/R6.
//

import FirebaseAuth
import SwiftUICore

@MainActor
class PasswordResetViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    @Published var isSuccessSending = false


    func onTappedSendButton() {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self else { return }
            if let error = error {
                switch error.localizedDescription {
                case "The email address is badly formatted.":
                    errorMessage = "メールアドレスの形式が正しくありません"
                default:
                    errorMessage = "エラーが発生しました"
                }
            } else {
                isSuccessSending = true
            }
        }
    }
}
