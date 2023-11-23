//
//  JoinGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestoreSwift

struct JoinGroupView: View {
    @StateObject var viewModel = JoinGroupViewModel()
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
<<<<<<< HEAD:MusicSync/View/JoinGroupView.swift
            if isLoading {
                LoadingView(text: "Now loading")
=======
            
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
>>>>>>> future:MusicSync/Views/JoinGroupView.swift
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

        JoinGroupView(path: $path, userName: "userName", roomPin: "333333")
    }
}
