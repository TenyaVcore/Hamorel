//
//  LoginView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

struct LogInView<Repo: AuthRepositoryProtocol>: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage = ""
    @State private var isSuccessLogin = false
    @State private var isError = false
    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            Text("LOG IN")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 40)

            Text(errorMessage)
                .foregroundColor(.red)

            TextField("mail address", text: $email)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 50)
                .autocapitalization(.none)

            SecureField("password", text: $password)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .padding(.horizontal, 50).padding(.vertical, 15)

            Button(action: {
                Auth.auth().signIn(withEmail: email, password: password) { _, _ in
                    isSuccessLogin = true
                }
            }, label: {
                ButtonView(text: "ログイン", buttonColor: .blue)
            }).padding()

            NavigationLink(value: NavigationLinkItem.passwordReset) {
                ButtonView(text: "パスワードを忘れた方はこちら", buttonColor: .gray)
            }.padding()

            NavigationLink(value: NavigationLinkItem.register) {
                ButtonView(text: "未登録の方はこちら", buttonColor: .gray)
            }.padding()

            Button {
                Task {
                    do {
                        try await Repo.loginAsGuest()
                    } catch {
                        isError = true
                    }
                }
            } label: {
                ButtonView(text: "ゲストとしてログイン", buttonColor: .teal)
            }.padding()
        }
        .alert("ログインに成功しました", isPresented: $isSuccessLogin) {
            Button("OK") {
                router.popToRoot()
            }
        }
        .alert("エラーが発生しました", isPresented: $isError) {
            Button("OK") {}
        }
    }
}

#Preview {
    LogInView<FirebaseAuthRepository>()
}
