//
//  EmailRegisterView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

struct EmailRegisterView: View {
    @StateObject var viewModel = EmailRegisterViewModel()
    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            ZStack {
                RoundedCorners(color: Color("color_primary"), tl: 10, tr: 10, bl: 10, br: 10)
                    .frame(height: 100)
                    .padding()

                Text("新規登録")
                    .font(.title)
                    .fontWeight(.bold)
            }

            Text(viewModel.errorMessage)
                .foregroundStyle(Color.red)
                .font(.caption)
                .padding()

            Text("ユーザー名")
            TextField("name", text: $viewModel.name)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            Text("メールアドレス")
            TextField("email address", text: $viewModel.email)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            Text("パスワード")
            SecureField("password", text: $viewModel.password)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            Button(
                action: {
                    viewModel.onTappedRegisterButton { result in
                        if result { self.router.push(.provision) }
                    }
                },
                label: {
                    ButtonView(text: "登録する", buttonColor: .primary)
                }).padding()
        }
    }
}

struct EmailRegisterView_Previews: PreviewProvider {
    @State static var previewPath = [NavigationLinkItem]()
    static var previews: some View {
        EmailRegisterView()
    }
}
