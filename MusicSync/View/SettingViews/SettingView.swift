//
//  SettingView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

import SwiftUI
import MusicKit
import Firebase
import FirebaseFirestoreSwift

struct SettingModel: Identifiable {
    var id: Int
    var title: String
    var destination: any View
}

struct SettingView: View {
    
    @AppStorage("name") var name = "ゲストユーザー"
    @AppStorage("isLogined") var isLogined: Bool = false
    
    @State private var appleAuthStatus: MusicAuthorization.Status
    @State private var logOutAlert: Bool = false
    @State private var isSettingName = false
    
    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }
    
    
    var body: some View {
        List{
            Section{
                HStack{
                    Text("現在のログインステータス：")
                    
                    switch Auth.auth().currentUser?.isAnonymous{
                    case true:
                        Text("ゲストとしてログイン")
                    case false:
                        Text("メールアドレスでログイン")
                    default:
                        Text("未定義")
                    }
                }
                HStack{
                    Text("現在のApple Music ステータス:")
                    
                    switch appleAuthStatus {
                    case .notDetermined:
                        Text("未定義")
                    case .authorized:
                        Text("許可")
                    case .denied:
                        Text("拒否")
                    case .restricted:
                        Text("アクセス不可")
                    @unknown default:
                        Text("不明なエラー")
                    }
                }
            }header: {
                Text("ユーザーステータス")
            }
            Section{
                Button {
                    isSettingName.toggle()
                } label: {
                    Text("ユーザー名:　\(name)")
                }
                .fullScreenCover(isPresented: $isSettingName) {
                    NameSettingView()
                }

                NavigationLink(destination: PasswordResetView(), label: {Text("パスワードの変更")})
            }header: {
                Text("ユーザ情報の変更")
            }
            
            
            Button(action: {
                self.logOutAlert = true
            }, label: {
                Text("ログアウト")
                    .foregroundColor(.red)
                    .bold()
            })
            .alert("本当にログアウトしますか？", isPresented: $logOutAlert) {
                Button("キャンセル"){}

                Button("OK"){
                    do {
                        try Auth.auth().signOut()
                        isLogined = false
                    }
                    catch let error as NSError {
                        print(error)
                    }
                }
                
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
