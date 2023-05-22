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
    @State private var SucceedRegist:Bool = false
    @State private var errorMessage = ""
    
    var authModel = FirebaseAuthModel()
    
    var body: some View {
        if SucceedRegist {
            ProvisionalRegistrationView()
        }else{
            VStack{
                Text("新規登録")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(errorMessage)
                
                TextField("name", text: $name).padding().textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                TextField("email address", text: $email).padding().textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                TextField("password", text: $password).padding().textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Text(errorMessage)
                
                Button(action: {
                    if let error = authModel.createUser(email: email, name: name, password: password) {
                        errorMessage = error.localizedDescription
                    } else {
                        SucceedRegist = true
                        
                    }
                    
                }, label: {
                    Text("登録する")
                }).padding()
            }
        }
    }
}

struct EmailRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        EmailRegisterView()
    }
}
