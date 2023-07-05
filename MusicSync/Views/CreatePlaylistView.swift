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
    @State var createdPlaylist = false
    
    var roomPin: Int
    var usersData: [UserData]
    
    var body: some View {
        ZStack{
            VStack{
                Text("プレイリストを作成しました！")
                    .padding(40)
                
                Button {
                    self.isLoginViewActive = false
                } label: {
                    ButtonView(text: "OK", buttonColor: .blue)
                }
                .alert("エラー：\(viewModel.errorMessage)", isPresented: $isShowingAlert){
                    Button("OK"){
                        isLoginViewActive = false
                    }
                }
            }
            
            LoadingView()
            
        }
        .onAppear{
            print("create playlist")
            viewModel.createsPlaylist(roomPin: roomPin, usersData: usersData){ result in
                switch result{
                case .success(let name):
                    self.createdPlaylist = true
                    
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
        CreatePlaylistView(isLoginViewActive: $state, roomPin: 0, usersData: [UserData(name: "aa")])
    }
}
