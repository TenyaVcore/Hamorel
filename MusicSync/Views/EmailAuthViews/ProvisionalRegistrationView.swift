//
//  ProvisionalRegistrationView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct ProvisionalRegistrationView: View {
    @Binding var path: [NavigationLinkItem]

    var body: some View {
        VStack {
            Text("メールアドレスに確認メールを送信しました")

            Button {
                path.removeLast(path.count - 1)
            } label: {
                ButtonView(text: "ログイン画面に戻る", buttonColor: .colorPrimary)
            }

            Text("メールが届かない場合")
        }
    }
}

struct ProvisionalRegistrationView_Previews: PreviewProvider {
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        ProvisionalRegistrationView(path: $path)
    }
}
