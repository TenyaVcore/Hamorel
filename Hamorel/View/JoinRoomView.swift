//
//  JoinRoomView.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct JoinRoomView: View {
    @StateObject private var viewModel: JoinRoomViewModel
    @EnvironmentObject private var router: Router

    init (roomPin: String) {
        _viewModel = StateObject(wrappedValue: JoinRoomViewModel(roomPin: roomPin))
    }

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
                    viewModel.onTappedExitButton()
                }, label: {
                    ButtonView(text: "roomを退出",
                               textColor: .black,
                               buttonColor: Color("color_secondary")
                    )
                })
                .padding(.bottom, 10)
            }

            LoadingView(message: "ルームに参加中")
                .opacity(viewModel.isLoading ? 1 : 0)
                .animation(.easeInOut, value: viewModel.isLoading)
        }
        .navigationDestination(isPresented: $viewModel.nextFlag) {
            router.navigate(item: .playlist(viewModel.roomPin))
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isError, actions: {
            Button("OK") { router.pop() }
        })
    }
}

struct JoinGroupView_Previews: PreviewProvider {
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {
        JoinRoomView(roomPin: "333333")
    }
}
