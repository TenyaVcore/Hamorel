//
//  CreatePlaylistView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct CreatePlaylistView: View {
    @StateObject var viewModel = CreatePlaylistViewModel()
<<<<<<< HEAD:MusicSync/View/CreatePlaylistView.swift
    
    @Binding var isLoginViewActive: Bool
    @State var isShowingAlert = false
    @State var isLoading = true
    
    var roomPin: Int
    var usersData: [UserData]
    
    var body: some View {
        ZStack{
            VStack{
                Image("playlist image")
                    .resizable()
                    .scaledToFit()
                    .border(Color.blue, width: 3)
                    .padding(40)
                Text("プレイリストを作成しました！\nAppleMusicを確認してみよう！")
                    .font(.title2)
                    
                
                Button {
                    self.isLoginViewActive = false
                } label: {
                    ButtonView(text: "OK", buttonColor: .blue)
                }
                .padding(40)
                .alert("エラー：\(viewModel.errorMessage)", isPresented: $isShowingAlert){
                    Button("OK"){
                        isLoginViewActive = false
                    }
                }
            }
            
            if isLoading{ LoadingView(text: "Now loading")}
            
        }
        .onAppear{
            print("create playlist")
            viewModel.createsPlaylist(roomPin: roomPin, usersData: usersData){ result in
                switch result{
                case .success(let name):
                    self.isLoading = false
                    
                case .failure(let error):
                    isShowingAlert = true
                    
                }
            }
            
=======
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
>>>>>>> future:MusicSync/Views/CreatePlaylistView.swift
        }
    }
}

struct createPlaylistView_Previews: PreviewProvider {
    var viewModel = CreatePlaylistViewModel()
    @State static var state = true
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
<<<<<<< HEAD:MusicSync/View/CreatePlaylistView.swift
        CreatePlaylistView(isLoginViewActive: $state, isLoading: false, roomPin: 0, usersData: [UserData(name: "aa")])
=======
        let mock = ["aa", "bb", "cc", "dd", "ee"]
        CreatePlaylistView(path: $path, roomPin: "0", users: mock)
>>>>>>> future:MusicSync/Views/CreatePlaylistView.swift
    }
}
