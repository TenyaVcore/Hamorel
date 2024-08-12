//
//  CreateRoomView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct CreateRoomView: View {
    @StateObject var viewModel = CreateRoomViewModel()
    @Binding var path: [NavigationLinkItem]

    var userName: String

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color("color_primary"))
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

                Text("ルームに参加中のメンバー \(viewModel.usersData.count)/5 ")
                    .font(.title2)

                List(viewModel.usersData) { userData in
                    MemberListCell(name: userData.name)
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    viewModel.pushNext()
                    path.append(NavigationLinkItem.playlist(String(viewModel.roomPin)))
                }, label: {
                    ButtonView(text: "次へ",
                               buttonColor: viewModel.usersData.count <= 1 ? .gray : Color("color_primary")
                    )
                })
                .padding(.bottom, 10)
                .disabled(viewModel.usersData.count <= 1)

                Button(action: {
                    viewModel.deleteGroup()
                    path.removeLast()
                }, label: {
                    ButtonView(text: "roomを解散",
                               textColor: .black,
                               buttonColor: Color("color_secondary")
                    )
                })
                .padding(.bottom, 10)
            }

            LoadingView(message: "ルームを作成中")
                .opacity(viewModel.isLoading ? 1 : 0)
                .animation(.easeInOut, value: viewModel.isLoading)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.createGroup(userName: userName)
            viewModel.usersData = [UserData(name: userName)]
        }
        .onDisappear {
            if !viewModel.nextFlag {
                viewModel.deleteGroup()
            }
        }
        .alert("エラーが発生しました。もう一度お試しください", isPresented: $viewModel.isError, actions: {
            Button("OK") { path.removeLast() }
        })
    }
}

struct createGroupView_Previews: PreviewProvider {
    @State static var state = true
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        CreateRoomView(path: $path, userName: "preuser")
    }
}
