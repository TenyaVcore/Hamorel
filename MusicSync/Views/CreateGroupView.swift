//
//  CreateGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct CreateGroupView: View {
    
    @StateObject var viewModel = CreateGroupViewModel()
    @State var listener: ListenerRegistration?
    
    var name: String
    
    var body: some View {
        
        ZStack{
            VStack{
                List(viewModel.usersData){ userdata in
                    Text(userdata.name)
                }
                .onAppear {
                    LoadingControl.shared.showLoading()
                    let result = viewModel.createGroup(userName: name)
                    listener = result.0
                    viewModel.pubRoomPin = result.1
                    
                }
                
                Text("room Pin:\(viewModel.pubRoomPin)")
                    .padding(30)
                
                NavigationLink("プレイリストを作成する",
                               destination: CreatePlaylistView(roomPin: viewModel.pubRoomPin, usersData: viewModel.usersData))
                .disabled(viewModel.usersData.count <= 1)
                
                
                Spacer()
            }
            
            if LoadingControl.shared.isLoading { LoadingView() }
            
        }
       
        .onDisappear {
            if let listener = listener {
                listener.remove()
            }
            
            viewModel.exitGroup(roomPin: viewModel.pubRoomPin)
        }
    }
}

struct createGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(name: "preuser")
    }
}
