//
//  EmailRegisterView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

struct EmailRegisterView: View {
    
    @State private var name:String = ""
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var errorMessage = ""
    @Binding var path:[NavigationLinkItem]
    
    var authModel = FirebaseAuthModel()
    
    var body: some View {
        VStack{
            ZStack{
                RoundedCorners(color: Color("Color_primary"), tl: 10, tr: 10, bl: 10, br: 10)
                    .frame(height: 100)
                    .padding()
                
                Text("新規登録")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Text(errorMessage)
                .foregroundStyle(Color.red)
                .font(.caption)
                .padding()
            
            Text("ユーザー名")
            TextField("name", text: $name)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            Text("メールアドレス")
            TextField("email address", text: $email)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            Text("パスワード")
            SecureField("password", text: $password)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            Button(action: {
                if !validateForm() {
                    return
                }
                
                if let error = authModel.createUser(email: email, name: name, password: password) {
                    errorMessage = error.localizedDescription
                } else {
                    path.append(NavigationLinkItem.provision)
                }
                
            }, label: {
                ButtonView(text: "登録する", buttonColor: .colorPrimary)
            }).padding()
        }
    }
    
    private func validateForm() -> Bool {
        //name
        if self.name.count < 2 || self.name.count > 20 {
            errorMessage = "ユーザー名は2文字以上20文字以下で入力してください"
            return false
        }
        
        //email
        if !self.email.contains("@") {
            errorMessage = "メールアドレスを正しく入力してください"
            return false
        }
        
        //password
        if self.password.count < 8 || self.password.count > 20 {
            errorMessage = "パスワードは8文字以上20文字以下で入力してください"
            return false
        }
        if self.password.rangeOfCharacter(from: .decimalDigits) == nil {
            errorMessage = "パスワードは文字列と数字の両方を含めてください"
            return false
        }
        if Int(self.password) != nil {
            errorMessage = "パスワードは文字列と数字の両方を含めてください"
            return false
        }
        return true
    }
}



struct EmailRegisterView_Previews: PreviewProvider {
    @State static var previewPath = [NavigationLinkItem]()
    static var previews: some View {
        EmailRegisterView(path: $previewPath)
    }
}
