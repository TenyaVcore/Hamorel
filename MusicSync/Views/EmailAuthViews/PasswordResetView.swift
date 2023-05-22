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
    
    var body: some View {
        VStack{
            Text("パスワードをリセット")
                .font(.largeTitle)
                .bold()
            
            Text("メールアドレスにパスワード再設定用メールを送信します")
                .multilineTextAlignment(.center)
                
            
            TextField("メールアドレスを入力", text: $email)
                .padding(.horizontal, 60)
                .padding(.top, 60)
            
            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.bottom, 50)
            
            
            Button {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    switch error?.localizedDescription {
                    case "The email address is badly formatted.":
                        errorMessage = "メールアドレスの形式が正しくありません"
                    default:
                        errorMessage = "エラーが発生しました"
                    }
                }
            } label: {
                ButtonView(text: "メールを送信", buttonColor: email == "" ? .gray : .blue)
            }
            .disabled(email == "")

        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
