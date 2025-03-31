//
//  EmailRegisterViewModel.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/11/05.
//

import SwiftUI
import Firebase

@MainActor
class EmailRegisterViewModel: ObservableObject {
    private let useCase = EmailRegisterUseCase<FirebaseAuthRepository>()

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage = ""

    /// trueを返したら画面遷移
    func onTappedRegisterButton(shouldNavigate: @escaping (Bool) -> Void) {
        let error = useCase.validateForm(name: name, email: email, password: password)
        if let error = error {
            errorMessage = error
            shouldNavigate(false)
        }

        Task {
            do {
                try await useCase.createUser(name: name, email: email, password: password)
                shouldNavigate(true)
            } catch {
                errorMessage = useCase.convertErrorToMessage(error: error)
                shouldNavigate(false)
            }
        }
    }

}
