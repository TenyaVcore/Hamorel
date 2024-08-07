//
//  JoinRoomView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Combine

struct JoinRoomView: View {
    @StateObject var viewModel = JoinRoomViewModel()
    @Binding var path: [NavigationLinkItem]
    
    // 前のviewからの引き継ぎ
    var userName: String
    var roomPin: String
    @State var cancellable: AnyCancellable!
    
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
                    path.removeLast()
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
        .onAppear {
            viewModel.roomPin = roomPin
            viewModel.joinGroup(userName: userName)
            self.cancellable = viewModel.$nextFlag.sink {
                if $0 {
                    path.append(NavigationLinkItem.playlist(viewModel.roomPin))
                }
            }
        }
        .onDisappear {
            if !viewModel.nextFlag {
                viewModel.exitGroup()
            }
            cancellable.cancel()
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isError, actions: {
            Button("OK") { path.removeLast() }
        })
    }
}

struct JoinGroupView_Previews: PreviewProvider {
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {

        JoinRoomView(path: $path, userName: "userName", roomPin: "333333")
    }
}
