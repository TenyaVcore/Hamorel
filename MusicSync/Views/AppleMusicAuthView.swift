//
//  AppleMusicAuthView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit

struct AppleMusicAuthView: View {
    
    @Binding var appleAuthStatus: MusicAuthorization.Status
    
    
    
    var body: some View {
        ZStack{
            Color(.gray)
                .opacity(0.6)
                .ignoresSafeArea(.all)
            VStack{
                Text("Apple Music Libraryへの\nアクセス権限が必要です。")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Divider()
                    
                
                VStack{
                    Text("現在のステータス:")
                        .padding(.bottom ,10)
                        .font(.title3)
                    
                    switch appleAuthStatus {
                    case .notDetermined:
                        Text("ステータスは定義されていません")
                    case .authorized:
                        Text("ライブラリへのアクセスが許可されています")
                    case .denied:
                        VStack{
                            Text("ライブラリへのアクセスが拒否されました。")
                            Text("設定からメディアとAppleMusicへのアクセスを許可してください。")
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                        }
                    case .restricted:
                        Text("設定にアクセスできません")
                    @unknown default:
                        Text("不明なエラーが発生しました")
                    }
                }.padding()
                
                Button {
                    Task{
                        await _ = MusicAuthorization.request()
                        self.appleAuthStatus = MusicAuthorization.currentStatus
                    }
                } label: {
                    ButtonView(text: "AppleMusicライブラリへの\nアクセスを許可", buttonColor: .blue)
                        .padding(25)
                }
                
            }
            .background(.background)
            .border(Color.blue, width: 3)
            .shadow(radius: 5)
            .padding()
        }
    }
}

struct appleMusicAuthView_Previews: PreviewProvider {
    @State static var status = MusicAuthorization.Status.denied
    static var previews: some View {
        AppleMusicAuthView(appleAuthStatus: $status)
            .previewLayout(.sizeThatFits)
    }
}
