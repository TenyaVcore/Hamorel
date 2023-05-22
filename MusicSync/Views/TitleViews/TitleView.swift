//
//  TitleView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit

struct TitleView: View {
    
    @State private var appleAuthStatus: MusicAuthorization.Status
    
    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                
                VStack{
                    
                    Spacer()
                    
                    Text("MUSIC SYNC")
                        .font(.system(size: 60,weight: .bold))
                        .foregroundColor(.white)
                        .padding(18)
                    
                    
                    Image("Icon_MusicSync")
                        .resizable()
                        .foregroundColor(Color.white)
                        .scaledToFit()
                        .padding(50)
                    
                    
                    NavigationLink(destination: LogInView(), label: {StartButtonView()})
                        .padding()
                    
                    Spacer()
                    
                }
                .background(.black)
                .toolbar {
                    ToolbarItem (placement: .navigationBarTrailing){
                        NavigationLink(destination:SettingView() ,
                                       label: {Image(systemName: "gearshape")
                                .resizable()
                                .foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 50)
                        })


                    }
                }
                
                
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
