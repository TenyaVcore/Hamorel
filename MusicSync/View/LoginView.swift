//
//  LoginView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

struct LogInView: View {
<<<<<<< HEAD:MusicSync/View/LoginView.swift
    @AppStorage("isLogined") var isLogined: Bool = false
    @AppStorage("name") var name = "ゲストユーザー"
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var errorMessages = ""
    
=======
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage = ""
    @State private var isSuccessLogin = false
    @Binding var path: [NavigationLinkItem]

>>>>>>> future:MusicSync/Views/LoginView.swift
    var model = FirebaseAuthModel()

    var body: some View {
<<<<<<< HEAD:MusicSync/View/LoginView.swift
        if isLogined {
            HomeView()
        }else{
            VStack{
                
                Text("LOG IN")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 40)
                    
                
                Text(errorMessages)
                    .foregroundColor(.red)
                
                TextField("mail address", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 50)
                    .autocapitalization(.none)
                
                TextField("password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .padding(.horizontal, 50).padding(.vertical, 15)
=======
        VStack {
            Text("LOG IN")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 40)

            Text(errorMessage)
                .foregroundColor(.red)

            TextField("mail address", text: $email)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 50)
                .autocapitalization(.none)

            SecureField("password", text: $password)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .padding(.horizontal, 50).padding(.vertical, 15)

            Button(action: {
                Auth.auth().signIn(withEmail: email, password: password) { _, _ in
                    isSuccessLogin = true
                }
            }, label: {
                ButtonView(text: "ログイン", buttonColor: .blue)
            }).padding()
>>>>>>> future:MusicSync/Views/LoginView.swift

            NavigationLink(value: NavigationLinkItem.passwordReset) {
                ButtonView(text: "パスワードを忘れた方はこちら", buttonColor: .gray)
            }.padding()

            NavigationLink(value: NavigationLinkItem.register) {
                ButtonView(text: "未登録の方はこちら", buttonColor: .gray)
            }.padding()

            Button {
                model.loginAsGuest { error in
                    if error != nil {
                        errorMessage = "エラーが発生しました"
                    } else {
                        isSuccessLogin = true
                    }
                }
            } label: {
                ButtonView(text: "ゲストとしてログイン", buttonColor: .teal)
            }.padding()
        }
        .alert("ログインに成功しました", isPresented: $isSuccessLogin) {
            Button("OK") {
                path.removeAll()
            }
        }
    }
}

<<<<<<< HEAD:MusicSync/View/LoginView.swift


=======
>>>>>>> future:MusicSync/Views/LoginView.swift
struct LoginView_Previews: PreviewProvider {
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        LogInView(path: $path)
    }
}
