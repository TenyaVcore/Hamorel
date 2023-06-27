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
    var musicmodel = AppleMusicLibraryModel()
    
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
//                    Button("ライブラリから"){
//                        musicmodel.loadLibrary { result in
//                            do{
//                                let res = try result.get()
//                                print(res)
//                                Task{
//                                    do {try await MusicLibrary.shared.createPlaylist(name: "1つ", items: res)}
//                                    catch{print("error: \(error)")}
//                                }
//                            }catch{
//                                print(error)
//                            }
//                        }
//                    }
//
//                    Button("1つだけ作成"){
//                        model.fetchUserData(roomPin: 489366, userData: UserData(id: "29048C80-15EE-401B-8F9B-F661B2EA4C54", name: "さいと"), completion: { result in
//                            do{
//                                let data = try result.get()
//                                print("data: \(data)")
//                                Task{
//                                    do {try await MusicLibrary.shared.createPlaylist(name: "1つ", items: data)}
//                                    catch{print("error: \(error)")}
//                                }
//                            }catch{
//                                print("error: \(error)")
//                            }
//                        })
//                    }.padding()
//
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
