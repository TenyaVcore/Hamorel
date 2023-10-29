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
    
    @EnvironmentObject var transData: EnvironmentData
    
    @State var appleAuthStatus: MusicAuthorization.Status
    @State private var isCreateActive = false
    @State private var isJoinActive = false
    @State private var roomPin:String = ""
    @State private var isActive = false
    
    let libraryModel = AppleMusicLibraryModel()
    let firestoreModel = FirestoreModel()
    let model = JoinGroupViewModel()
    
    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    
                    Text("Name: \(name)")
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .padding(.bottom, 10)
                    
                    
                    NavigationLink(destination: CreateGroupView(isLoginViewActive: $isActive, name: name),
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
                        .multilineTextAlignment(.center)
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
                    
                    
                    NavigationLink(destination: JoinGroupView(isLoginViewActive: $isActive, name: name, roomPin: roomPin),
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
                    }else{
                        Text("\n")
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
            }
        }
    }
}


class EnvironmentData: ObservableObject {
    @Published var isNavigationActive: Binding<Bool> = Binding<Bool>.constant(false)
}


struct homeView_Previews: PreviewProvider {
    @State static var active = true
    static var previews: some View {
        HomeView()
    }
}

