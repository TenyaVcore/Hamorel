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
    @State var listener: ListenerRegistration?
    
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
                
                
                
                NavigationLink("プレイリストを作成する",
                               destination: CreatePlaylistView(roomPin: Int(roomPin) ?? 0, usersData: viewModel.usersData))
                
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
    static var previews: some View {
        AfterJoinView(name: "userName", roomPin: "333333")
    }
}
