//
//  JoinGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct JoinGroupView: View {
    @StateObject var viewModel = JoinGroupViewModel()
    @State private var isLoading = true
    @State private var listener: ListenerRegistration?
    @State private var isActive = false
    @Binding var isLoginViewActive: Bool
    
    
    var name: String
    var roomPin: String
    
    var body: some View {
        ZStack{
            VStack{
                ProgressView("ユーザーを待機中")
                    .font(.title2)
                    .padding(.top, 50)
                
                List(viewModel.usersData){ userdata in
                    Text(userdata.name)
                }
                .onAppear{
                    listener = viewModel.joinGroup(roomPin: Int(roomPin) ?? 0, user: name)
                    isLoading = false
                }
                
                
                NavigationLink(destination: CreatePlaylistView(isLoginViewActive: $isLoginViewActive, roomPin: Int(roomPin) ?? 0, usersData: viewModel.usersData),
                               isActive: $isActive){
                    Button {
                        self.isActive = true
                    } label: {
                        ButtonView(text: "プレイリストを作成する", buttonColor: .blue)
                    }
                    .alert("エラー：\(viewModel.errorMessage)", isPresented: $viewModel.isShowingAlert){
                        Button("OK"){
                            isLoginViewActive = false
                        }
                    }
                }
                
            }
            if isLoading {
                LoadingView()
            }
        }
        .onDisappear {
            if let listener = listener {
                listener.remove()
            }
            //viewModel.exitGroup(roomPin: Int(roomPin) ?? 0)
        }
    }
}

struct JoinGroupView_Previews: PreviewProvider {
    @State static var state = true
    static var previews: some View {
        JoinGroupView(isLoginViewActive: $state, name: "userName", roomPin: "333333")
    }
}
