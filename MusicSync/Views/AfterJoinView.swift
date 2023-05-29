//
//  AfterJoinView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct AfterJoinView: View {
    @StateObject var viewModel = JoinGroupViewModel()
    @State private var isLoading = true
    @State private var listener: ListenerRegistration?
    @State private var isActive = false
    @Binding var isTitleViewActive: Bool
    
    
    var name: String
    var roomPin: String
    
    var body: some View {
        ZStack{
            VStack{
                List(viewModel.usersData){ userdata in
                    Text(userdata.name)
                }
                .onAppear{
                    listener = viewModel.joinGroup(roomPin: Int(roomPin) ?? 0, user: name)
                    isLoading = false
                }
                
                
                NavigationLink(destination: CreatePlaylistView(isTitleViewActive: $isTitleViewActive, roomPin: Int(roomPin) ?? 0, usersData: viewModel.usersData),
                               isActive: $isActive){
                    Button {
                        self.isActive = true
                    } label: {
                        ButtonView(text: "プレイリストを作成する", buttonColor: .blue)
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
            viewModel.exitGroup(roomPin: Int(roomPin) ?? 0)
        }
    }
}

struct afterJoinView_Previews: PreviewProvider {
    @State static var state = true
    static var previews: some View {
        AfterJoinView(isTitleViewActive: $state, name: "userName", roomPin: "333333")
    }
}
