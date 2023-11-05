//
//  CreateGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import MusicKit

struct CreateGroupView: View {
    
    @State var listener: ListenerRegistration?
    @State var nextFlag = false
    @StateObject var viewModel = CreateGroupViewModel()
    @Binding var path: NavigationPath
    
    var name: String
    var roomPin = "0"
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle(Color("Color_primary"))
                    .frame(width: 340, height:120)
                    .cornerRadius(20)
                
                VStack{
                    Text("Room Pin")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text((roomPin))
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            
            Text("ルームに参加中のメンバー 1/5 ")
                .font(.title2)
                
            List{
                MemberListCell(name: "ユーザ1")
                MemberListCell(name: "ユーザ2")
                MemberListCell(name: "ユーザ3")
                MemberListCell(name: "ユーザ4")
                MemberListCell(name: "ユーザ5")
            }
            .listStyle(PlainListStyle())
            
            
            NavigationLink(value: NavigationLinkItem.playlist(roomPin)) {
                ButtonView(text: "次へ", buttonColor: Color("Color_primary"))
            }

            
            
            Button(action: {
                path.removeLast()
            }, label: {
                ButtonView(text: "roomを解散する", textColor: .black, buttonColor: Color("Color_secondary"))
            })
            .padding(.bottom, 10)
        }
    }
}

struct createGroupView_Previews: PreviewProvider {
    @State static var state = true
    @State static var path = NavigationPath()
    static var previews: some View {
        CreateGroupView(path: $path ,name: "preuser")
    }
}
