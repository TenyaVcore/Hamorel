//
//  NameSettingView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase

struct NameSettingView: View {
    @AppStorage("name") var name = "ゲストユーザー"
    @State var updateName: String = ""
    @Environment(\.dismiss) private var dismiss
    
    let model = FirebaseAuthModel()
    
    var body: some View {
        VStack{
            
            Text("新しい名前を入力")
                .font(.title)
                .bold()
            
            TextField("ユーザー名を入力してください", text: $updateName)
                .onAppear(){
                    updateName = name
                }
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .padding(60)
            
            
            
            Button {
                name = updateName
                model.changeUserName(newName: updateName)
                dismiss()
            } label: {
                ButtonView(text: "OK", buttonColor: .blue)
            }
            .padding(20)
            
            Button{
                dismiss()
            } label: {
                ButtonView(text: "キャンセル", buttonColor: .gray)
            }
        }
    }
}

struct NameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NameSettingView()
    }
}
