//
//  ProvisionalRegistrationView.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct ProvisionalRegistrationView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            Text("メールアドレスに確認メールを送信しました")

            Button {
                router.popToRoot()
            } label: {
                ButtonView(text: "ログイン画面に戻る", buttonColor: .primary)
            }

            Text("メールが届かない場合は迷惑メールフォルダをご確認ください")
        }
    }
}

#Preview {
    ProvisionalRegistrationView()
}
