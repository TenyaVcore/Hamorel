//
//  CreatePlaylistView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct CreatePlaylistView: View {
    @StateObject var viewModel = CreatePlaylistViewModel()
    
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
            
        }
    }
}

struct createPlaylistView_Previews: PreviewProvider {
    @State static var state = true
    static var previews: some View {
        CreatePlaylistView(isLoginViewActive: $state, isLoading: false, roomPin: 0, usersData: [UserData(name: "aa")])
    }
}
