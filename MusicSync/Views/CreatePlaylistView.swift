//
//  CreatePlaylistView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct CreatePlaylistView: View {
    @StateObject var viewModel = CreatePlaylistViewModel()
    
    var roomPin: Int
    var usersData: [UserData]
    
    var body: some View {
        VStack{
            Text("プレイリストを作成しました！")
                .padding(40)
            
            Button {
            } label: {
                ButtonView(text: "OK", buttonColor: .blue)
            }

            
        }
        .onAppear{
            viewModel.createsPlaylist(roomPin: roomPin, usersData: usersData)
        }
    }
}

struct createPlaylistView_Previews: PreviewProvider {
    @State static var state = true
    static var previews: some View {
        CreatePlaylistView(roomPin: 0, usersData: [UserData(name: "aa")])
    }
}
