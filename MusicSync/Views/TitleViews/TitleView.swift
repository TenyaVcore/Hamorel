//
//  TitleView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit

struct TitleView: View {
    
    @EnvironmentObject var transData: EnvironmentData
    
    @State private var appleAuthStatus: MusicAuthorization.Status
    @State private var isAnimation: Bool = false
    @State private var isActive = false
    
    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                
                VStack{
                    
                    Spacer()
                    
                    Text("MUSIC SYNC")
                        .font(.system(size: 55,weight: .bold))
                        .foregroundColor(.black)
                        .padding(18)
                    
                    
                    Image("Icon_MusicSync")
                        .resizable()
                        .foregroundColor(Color.white)
                        .scaledToFit()
                        .padding(50)
                    
                    
                    NavigationLink(destination: LogInView(isTitleViewActive: $isActive),isActive: $isActive ,
                                   label: {Button(action: {
                        self.isActive = true
                    }, label: {
                        StartButtonView()
                    })})
                        .padding()
                    
                    Spacer()
                    
                }
                .toolbar {
                    ToolbarItem (placement: .navigationBarTrailing){
                        NavigationLink(destination:SettingView() ,
                                       label: {Image(systemName: "gearshape")
                                .resizable()
                                .foregroundColor(.black)
                                .scaledToFit()
                                .frame(width: 50)
                        })
                        
                        
                    }
                }
                
                if appleAuthStatus != .authorized{
                    AppleMusicAuthView()
//                        .scaleEffect(isAnimation ? 1 : 0)
//                        .animation(.easeIn, value: isAnimation)
//                        .onAppear(){
//                            isAnimation = true
//                        }
                }
                    
                    
                
            }
        }
    }
}


//titleに戻る用
class EnvironmentData: ObservableObject {
    @Published var isNavigationActive: Binding<Bool> = Binding<Bool>.constant(false)
}



struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
