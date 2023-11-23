//
//  CreatePlaylistView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct CreatePlaylistView: View {
    @StateObject var viewModel = CreatePlaylistViewModel()
    @Binding var path: [NavigationLinkItem]

    var roomPin: String
    var users: [String]

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Color("color_primary")
                        .cornerRadius(12)
                        .padding(.horizontal, 5)
                        .frame(maxHeight: 450)
                    
                    VStack {
                        Text("プレイリストを作成")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 15)
                        
                        List(users, id: \.self) { user in
                            MemberListCell(name: user)
                        }
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: 360)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                    }
                }
                
                Text("プレイリスト名")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                TextField("プレイリスト名を入力", text: $viewModel.playlistName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)

                Button {
                    viewModel.createPlaylist()
                } label: {
                    ButtonView(text: "AppleMusicに追加する", buttonColor: Color("color_primary"))
                }
                .padding(.top, 15)
                
                Button {
                    viewModel.isReturnHome = true
                } label: {
                    ButtonView(text: "ホームに戻る", textColor: .black, buttonColor: Color("color_secondary"))
                }
                .padding()
            }

            if viewModel.isLoading {
                LoadingView(message: "楽曲データを取得中")
                    .opacity(viewModel.isLoading ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.isLoading)
            }
        }
        .onAppear {
            viewModel.downloadSongs(roomPin: roomPin)
        }
        .alert("ホームに戻りますか", isPresented: $viewModel.isReturnHome) {
            Button("ホームに戻る", role: .destructive) {
                path.removeAll()
            }
            Button("キャンセル", role: .cancel) {
                viewModel.isReturnHome = false
            }
        }
        .alert("ダウンロード中にエラーが発生しました。", isPresented: $viewModel.isDownloadError) {
            Button("再試行") {
                viewModel.downloadSongs(roomPin: roomPin)
            }
        }
        .alert("プレイリスト作成に失敗しました。", isPresented: $viewModel.isCreateError) {
            Button("戻る", role: .cancel) {
                viewModel.isCreateError = false
            }
        }
        .alert("プレイリストの作成に成功しました。\n ＊反映されるまで時間がかかる場合があります。", isPresented: $viewModel.isSuccessCreate) {
            Button("OK") {
                viewModel.isSuccessCreate = false
            }
        }
    }
}

struct createPlaylistView_Previews: PreviewProvider {
    var viewModel = CreatePlaylistViewModel()
    @State static var state = true
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        let mock = ["aa", "bb", "cc", "dd", "ee"]
        CreatePlaylistView(path: $path, roomPin: "0", users: mock)
    }
}
