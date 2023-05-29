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
    var Name:String
    
    @State private var isLoading = false
    @State private var isActive = false
    @Binding var isTitleViewActive: Bool
    
    
    let libraryModel = AppleMusicLibraryModel()
    let firestoreModel = FirestoreModel()
    
    var body: some View {
            
        ZStack{
            
            if isLoading{LoadingView()}
            
            VStack{
                
                Text(Name)
                    .font(.system(size: 25, weight: .bold, design: .default))
                
                
                NavigationLink(destination: CreateGroupView(isTitleViewActive: $isTitleViewActive, name: Name),
                               isActive: $isActive){
                    Button {
                        self.isActive = true
                    } label: {
                        GroupButtonView(text: "グループを作成", buttonColor: .blue)
                    }
                    
                }
                               .isDetailLink(false)
                               .padding(40)
                
                NavigationLink(destination: JoinGroupView(isTitleViewActive: $isTitleViewActive, name: Name),
                               isActive: $isActive){
                    Button {
                        self.isActive = true
                    } label: {
                        GroupButtonView(text: "グループに参加", buttonColor: .red)
                    }
                    
                }
                               .isDetailLink(false)
                
                
            }
        }
    }
}

struct homeView_Previews: PreviewProvider {
    @State static var active = true
    static var previews: some View {
        HomeView(Name: "preview name", isTitleViewActive: $active)
    }
}
