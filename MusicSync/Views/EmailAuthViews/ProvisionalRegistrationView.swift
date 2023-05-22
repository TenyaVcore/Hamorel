//
//  ProvisionalRegistrationView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct ProvisionalRegistrationView: View {
    var body: some View {
        VStack{
            Text("メールアドレスに確認メールを送信しました")
            
            Text("ログイン画面へ")
                .padding(30)
            
            Text("メールが届かない場合")
        }
    }
}

struct ProvisionalRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ProvisionalRegistrationView()
    }
}
