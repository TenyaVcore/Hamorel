//
//  HomeView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

import SwiftUI
import MusicKit
import Firebase
import FirebaseFirestoreSwift

struct HomeView: View {
    
    @AppStorage("name") var name = "ゲストユーザー"
    
    @State var appleAuthStatus: MusicAuthorization.Status
    @State private var isCreateActive = false
    @State private var isJoinActive = false
    @State private var roomPin:String = ""
    @Binding var isLoginViewActive: Bool
    
    
    let libraryModel = AppleMusicLibraryModel()
    let firestoreModel = FirestoreModel()
    let model = JoinGroupViewModel()
    
    init(isLoginViewActive: Binding<Bool>) {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
        self._isLoginViewActive = isLoginViewActive
    }
    
    
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    Text("Name: \(name)")
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .padding(30)
                    
                    
                    NavigationLink(destination: CreateGroupView(isLoginViewActive: $isLoginViewActive, name: name),
                                   isActive: $isCreateActive){
                        Button {
                            self.isCreateActive = true
                        } label: {
                            GroupButtonView(text: "グループを作成", buttonColor: .blue)
                        }
                    }
                                   .isDetailLink(false)
                                   .padding(40)
                    
                    
                    Divider()
                    
                    
                    TextField("roomPin(6桁)を入力", text: $roomPin)
                        .keyboardType(.numberPad)
                        .autocapitalization(.none)
                        .font(.system(size: 25))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(.red,lineWidth: 3)
                        )
                        .padding(40)
                        .frame(maxWidth: 350)
                    
                    
                    NavigationLink(destination: JoinGroupView(isLoginViewActive: $isLoginViewActive, name: name, roomPin: roomPin),
                                   isActive: $isJoinActive){
                        Button {
                            self.isJoinActive = true
                        } label: {
                            GroupButtonView(text: "グループに参加", buttonColor: roomPin.count != 6 ? .red.opacity(0.4) : .red)
                        }
                    }
                                   .isDetailLink(false)
                                   .disabled(roomPin.count != 6)
                                   
                    if roomPin.count != 6 {
                        Text("グループに参加するには\n６桁のroomPinを入力してください")
                            .bold()
                            .foregroundColor(.red)
                            .padding(.horizontal, 40)
                    }
                    
                    
                }
                .toolbar {
                    ToolbarItem (placement: .navigationBarTrailing){
                        NavigationLink(destination:SettingView() ,
                                       label: {Image(systemName: "gearshape")
                                .resizable()
                                .foregroundColor(.primary)
                                .scaledToFit()
                                .frame(width: 50)
                        })
                    }
                }
                .toolbar{
                    ToolbarItem (placement: .navigationBarLeading){
                        NavigationLink(destination:SettingView() ,
                                       label: {Image(systemName: "questionmark.circle")
                                .resizable()
                                .foregroundColor(.primary)
                                .scaledToFit()
                                .frame(width: 50)
                        })
                    }
                }
                
//                if appleAuthStatus != .authorized {
//                    AppleMusicAuthView(appleAuthStatus: $appleAuthStatus)
//                        .scaleEffect(appleAuthStatus != .authorized ? 1 : 0)
//                        .animation(.easeIn, value: appleAuthStatus != .authorized)
//                }
            }
        }
    }
}



struct homeView_Previews: PreviewProvider {
    @State static var active = true
    static var previews: some View {
        HomeView(isLoginViewActive: $active)
    }
}

