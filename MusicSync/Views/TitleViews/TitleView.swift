//
//  TitleView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit

struct TitleView: View {
    
    //テスト
    var model = FirestoreModel()
    
    @EnvironmentObject var transData: EnvironmentData
    
    @State var appleAuthStatus: MusicAuthorization.Status
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
                    //テスト
                    Button("プレイリスト作成"){
                        model.downloadData(roomPin: 613901, usersData: [UserData(id: "29048C80-15EE-401B-8F9B-F661B2EA4C54", name: "さいと"), UserData(id: "A4700E05-9D3A-44E2-AE0F-04B99B1E583F" , name: "なつみかん")]) { result in
                            do{
                                let data = try result.get()
                                print("data[0]")
                                print(data[0])
                                 
                                print("data[1]")
                                print(data[1])
                                
                                Task{
                                    do{
                                        try await MusicLibrary.shared.createPlaylist(name: "1st Playlist", items: data[0] )
                                        print("1st finish")
                                    }catch{
                                        print("error: \(error)")
                                    }
                                    
                                    do{
                                        try await MusicLibrary.shared.createPlaylist(name: "2nd Playlist", items: data[1] )
                                        print("2nd finish")
                                    }catch{
                                        print("error: \(error)")
                                    }
                                }
                                
                                
                                
                            } catch {
                                print("error: \(error)")
                            }
                        }
                    }
                    //終わり
                    
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
                                .foregroundColor(.primary)
                                .scaledToFit()
                                .frame(width: 50)
                        })
                        
                        
                    }
                }
                
                if appleAuthStatus != .authorized {
                    AppleMusicAuthView(appleAuthStatus: $appleAuthStatus)
                        .scaleEffect(appleAuthStatus != .authorized ? 1 : 0)
                        .animation(.easeIn, value: appleAuthStatus != .authorized)
                    
                    
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
