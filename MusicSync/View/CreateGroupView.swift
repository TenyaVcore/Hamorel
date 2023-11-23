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
<<<<<<< HEAD:MusicSync/View/CreateGroupView.swift
            
            //if LoadingControl.shared.isLoading { LoadingView(text: "Now loading...") }
            
=======

            LoadingView(message: "ルームを作成中")
                .opacity(viewModel.isLoading ? 1 : 0)
                .animation(.easeInOut, value: viewModel.isLoading)
        }
        .onAppear {
            viewModel.createGroup(userName: userName)
            viewModel.usersData = [UserData(name: userName)]
>>>>>>> future:MusicSync/Views/CreateGroupView.swift
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
<<<<<<< HEAD:MusicSync/View/CreateGroupView.swift
    @State static var state = false
=======
    @State static var state = true
    @State static var path = [NavigationLinkItem]()
>>>>>>> future:MusicSync/Views/CreateGroupView.swift
    static var previews: some View {
        CreateGroupView(path: $path, userName: "preuser")
    }
}
