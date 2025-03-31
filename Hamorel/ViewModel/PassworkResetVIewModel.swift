//
//  PassworsResetViewModel.swift
//  Hamorel
//
//  Created by 田川展也 on 12/26/R6.
//

import SwiftUICore

@MainActor
class PasswordResetViewModel: ObservableObject {
    let authUseCase = AuthUseCase<FirebaseAuthRepository>()
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    @Published var isSuccessSending = false

    func onTappedSendButton() {
        Task {
            do {
                try await authUseCase.sendPasswordReset(email: email)
                isSuccessSending = true
            } catch {
                errorMessage = "エラーが発生しました"
            }
        }
    }
}
