//
//  HomeView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    var Name:String
    
    @State var isLoading = false
    
    var body: some View {
            
        ZStack{
            
            if isLoading{LoadingView()}
            
            VStack{
                
                Text(Name)
                    .font(.system(size: 25, weight: .bold, design: .default))
                
                NavigationLink(destination: CreateGroupView(name: Name),label: {Text("グループ作成").bold()})
                    .padding(40)
                NavigationLink(destination: JoinGroupView(name: Name), label: {Text("グループに参加").bold()})
                
            }
        }
    }
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(Name: "preview name")
    }
}
