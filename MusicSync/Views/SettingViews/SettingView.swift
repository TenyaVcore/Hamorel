//
//  SettingView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

import MusicKit
import Firebase
import FirebaseFirestoreSwift

struct SettingView: View {

    @State private var appleAuthStatus: MusicAuthorization.Status
    @State private var logOutAlert = false
    @State private var isSettingName = false

    @AppStorage("name") var name = "ゲストユーザー"

    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
        name = Auth.auth().currentUser?.displayName ?? "ゲストユーザー"
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Text("現在のログインステータス：")

                    switch Auth.auth().currentUser?.isAnonymous {
                    case true:
                        Text("ゲストとしてログイン")
                    case false:
                        Text("メールアドレスでログイン")
                    default:
                        Text("未選択")
                    }
                }
                HStack {
                    Text("現在のApple Music ステータス:")

                    switch appleAuthStatus {
                    case .notDetermined:
                        Text("未選択")
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
            Section {
                Button {
                    isSettingName.toggle()
                } label: {
                    Text("ユーザー名:　\(name)")
                }
                .fullScreenCover(isPresented: $isSettingName) {
                    NameSettingView()
                }

                NavigationLink(value: NavigationLinkItem.passwordReset) {
                    Text("パスワードの変更")
                }
            }header: {
                Text("ユーザ情報の変更")
            }
            
            Section {
                NavigationLink(value: NavigationLinkItem.licence) {
                    Text("ライセンス")
                }
            }header: {
                Text("規約")
            }

            if Auth.auth().currentUser?.isAnonymous != nil {
                Button(action: {
                    self.logOutAlert = true
                }, label: {
                    Text("ログアウト")
                        .foregroundColor(.red)
                        .bold()
                })
                .alert("本当にログアウトしますか？", isPresented: $logOutAlert) {
                    Button("キャンセル") {}

                    Button("OK") {
                        do {
                            try Auth.auth().signOut()
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
            } else {
                NavigationLink(value: NavigationLinkItem.login) {
                    Text("ログイン")
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
