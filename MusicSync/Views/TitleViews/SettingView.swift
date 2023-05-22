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
    
    @State private var appleAuthStatus: MusicAuthorization.Status
    
    
    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }
    
    
    var body: some View {
        List{
            Section{
                HStack{
                    Text("現在のログインステータス：")
                    
                    Text(Auth.auth().currentUser?.isAnonymous ?? true ? "ゲストとしてログイン" : "メールアドレスでログイン")
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
                NavigationLink(destination: NameSettingView(), label: {Text("ユーザー名:　\(name)")})
                NavigationLink(destination: PasswordResetView(), label: {Text("パスワードの変更")})
            }header: {
                Text("ユーザ情報の変更")
            }
            
            
            NavigationLink(destination: LogOutView(),
                           label: {Text("ログアウト")
                    .foregroundColor(.red)
                    .bold()
            })
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
