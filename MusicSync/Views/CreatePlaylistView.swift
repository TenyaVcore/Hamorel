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
    var usersData: [UserData]

    var body: some View {
        ZStack {
            VStack {
                Text("プレイリストを作成しました！")
                    .padding(40)

                Button {
                } label: {
                    ButtonView(text: "OK", buttonColor: .blue)
                }
            }

            LoadingView(message: "楽曲データを取得中")
                .opacity(viewModel.isLoading ? 1 : 0)
                .animation(.easeInOut, value: viewModel.isLoading)
        }
        .onAppear {
            viewModel.downloadSongs(roomPin: roomPin)
        }
    }
}

struct createPlaylistView_Previews: PreviewProvider {
    @State static var state = true
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        CreatePlaylistView(path: $path, roomPin: "0", usersData: [UserData(name: "aa")])
    }
}
