//
//  PasswordResetView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

struct PasswordResetView: View {

    @State var email: String = ""
    @State var errorMessage: String = ""
    @State var isSuccessSending = false
    @Binding var path: [NavigationLinkItem]

    var body: some View {
        VStack {
            ZStack {
                Color("color_primary")
                    .frame(height: 200)
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                    .shadow(color: Color.white.opacity(0.7), radius: 3, x: -3, y: -3)

                VStack {
                    Text("パスワードをリセット")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal, 30)

                    Text("メールアドレスにパスワード再設定用メールを送信します")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }

            TextField("メールアドレスを入力", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 60)
                .padding(.top, 60)

            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.bottom, 50)

            Button {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
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
            } label: {
                ButtonView(text: "メールを送信", buttonColor: email == "" ? .gray : Color("color_primary"))
            }
            .disabled(email == "")
        }
        .alert("パスワード再設定用のメールを送信しました", isPresented: $isSuccessSending) {
            Button("OK") {
                path.removeAll()
            }
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        PasswordResetView(path: $path)
    }
}
