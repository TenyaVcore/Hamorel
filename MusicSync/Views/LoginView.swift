//
//  LoginView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

struct LogInView: View {
    @AppStorage("isLogined") var isLogined: Bool = false
    @AppStorage("name") var name = "ゲストユーザー"
    
    
    @State var email:String = ""
    @State var password:String = ""
    @State var errorMessages = ""
    
    var model = FirebaseAuthModel()
    
    var body: some View {
        if isLogined {
            HomeView(Name: name)
        }else{
            VStack{
                
                Text("LOG IN")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 40)
                    
                
                Text(errorMessages)
                    .foregroundColor(.red)
                
                TextField("mail address", text: $email).textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 50)
                TextField("password", text: $password).textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 50).padding(.vertical, 15)
                
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let user = result?.user {
                            name = user.displayName ?? ""
                            isLogined = true
                        }
                    }
                }, label: {
                    ButtonView(text: "ログイン", buttonColor: .blue)
                }).padding()
                
                NavigationLink(destination: PasswordResetView(), label: {
                    ButtonView(text: "パスワードを忘れた方はこちら", buttonColor: .gray)
                }).padding()
                
                NavigationLink(destination: EmailRegisterView(), label: {
                    ButtonView(text: "未登録の方はこちら", buttonColor: .gray)
                }).padding()
                
                
                Button {
                    model.loginAsGuest()
                    isLogined = true
                } label: {
                    ButtonView(text: "ゲストとしてログイン", buttonColor: .teal)
                }.padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
