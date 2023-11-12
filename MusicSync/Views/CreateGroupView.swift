//
//  CreateGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct CreateGroupView: View {
    @StateObject var viewModel = CreateGroupViewModel()
    @Binding var path: [NavigationLinkItem]

    var name: String

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color("Color_primary"))
                        .frame(width: 340, height: 120)
                        .cornerRadius(20)

                    VStack {
                        Text("Room Pin")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .bold()

                        Text(String(viewModel.roomPin))
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .bold()
                    }
                }

                Text("ルームに参加中のメンバー 1/5 ")
                    .font(.title2)

                List(viewModel.usersData) { userData in
                    MemberListCell(name: userData.name)
                }
                .listStyle(PlainListStyle())

                NavigationLink(value: NavigationLinkItem.playlist(String(viewModel.roomPin))) {
                    ButtonView(text: "次へ", buttonColor: Color("Color_primary"))
                }
                .padding(.bottom, 10)

                Button(action: {
                    path.removeLast()
                }, label: {
                    ButtonView(text: "roomを解散", textColor: .black, buttonColor: Color("Color_secondary"))
                })
                .padding(.bottom, 10)
            }
            LoadingView(message: "ルームを作成中")
                .opacity(viewModel.isLoading ? 1 : 0)
                .animation(.easeInOut, value: viewModel.isLoading)
        }
        .onAppear {
            do {
                try viewModel.createGroup(userName: name)
            } catch {
                viewModel.isError = true
            }
        }
        .alert("ルーム作成中にエラーが発生しました。もう一度お試しください", isPresented: $viewModel.isError, actions: {
            Button("OK") { path.removeLast() }
        })
    }
}

struct createGroupView_Previews: PreviewProvider {
    @State static var state = true
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        CreateGroupView(path: $path, name: "preuser")
    }
}
