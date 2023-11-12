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

    @State var listener: ListenerRegistration?
    @StateObject var viewModel = CreateGroupViewModel()
    @Binding var path: [NavigationLinkItem]

    var name: String
    var roomPin = "000000"

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color("Color_primary"))
                    .frame(width: 340, height: 120)
                    .cornerRadius(20)

                VStack {
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

            List {
                MemberListCell(name: "ユーザ1")
                MemberListCell(name: "ユーザ2")
                MemberListCell(name: "ユーザ3")
                MemberListCell(name: "ユーザ4")
                MemberListCell(name: "ユーザ5")
            }
            .listStyle(PlainListStyle())

            Text("ホストの操作を待機しています...")

            Button(action: {
                path.removeLast()
            }, label: {
                ButtonView(text: "roomを退出する", textColor: .black, buttonColor: Color("Color_secondary"))
            })
            .padding(.bottom, 10)
        }
    }
}

struct JoinGroupView_Previews: PreviewProvider {
    @State static var state = true
    @State static var path = [NavigationLinkItem]()
    static var previews: some View {

        JoinGroupView(path: $path, name: "userName", roomPin: "333333")
    }
}
