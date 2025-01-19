//
//  NameSettingView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct NameSettingView<Repo: AuthRepositoryProtocol>: View {
    @State var updateName: String = ""
    @State var isError = false
    @Environment(\.dismiss) private var dismiss

    init() {
        updateName = Repo.fetchUser()?.name ?? "GuestUser"
    }

    var body: some View {
        VStack {

            Text("新しい名前を入力")
                .font(.title)
                .bold()

            TextField("ユーザー名を入力してください", text: $updateName)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .padding(60)

            Button {
                Task {
                    do {
                        try await Repo.changeUserName(newName: updateName)
                        dismiss()
                    } catch {
                        isError = true
                    }
                }
            } label: {
                ButtonView(text: "OK", buttonColor: .blue)
            }
            .padding(20)

            Button {
                dismiss()
            } label: {
                ButtonView(text: "キャンセル", buttonColor: .gray)
            }
        }
        .alert("エラーが発生しました", isPresented: $isError) {
            Button("OK") {
                isError = false
            }
        }
    }
}

struct NameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NameSettingView<FirebaseAuthRepository>()
    }
}
