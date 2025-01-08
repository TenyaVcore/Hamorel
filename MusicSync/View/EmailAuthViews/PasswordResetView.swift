//
//  PasswordResetView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct PasswordResetView: View {
    @ObservedObject private var viewModel = PasswordResetViewModel()
    @EnvironmentObject private var router: Router

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

            TextField("メールアドレスを入力", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 60)
                .padding(.top, 60)

            Text(viewModel.errorMessage)
                .foregroundColor(.red)
                .padding(.bottom, 50)

            Button {
                viewModel.onTappedSendButton()
            } label: {
                ButtonView(text: "メールを送信", buttonColor: viewModel.email == "" ? .gray : Color("color_primary"))
            }
            .disabled(viewModel.email == "")
        }
        .alert("パスワード再設定用のメールを送信しました", isPresented: $viewModel.isSuccessSending) {
            Button("OK") {
                router.popToRoot()
            }
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
