//
//  AppleMusicAuthView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit

struct AppleMusicAuthView: View {
    
    @State private var appleAuthStatus: MusicAuthorization.Status
    
    
    init() {
        _appleAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }
    
    
    var body: some View {
        ZStack{
            Color(.gray)
                .opacity(0.1)
                .ignoresSafeArea(.all)
            VStack{
                Text("Apple Music Libraryへの\nアクセス権限が必要です。")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                VStack{
                    Text("現在のステータス:")
                    
                    switch appleAuthStatus {
                    case .notDetermined:
                        Text("ステータスは定義されていません")
                    case .authorized:
                        Text("ライブラリへのアクセスが許可されています")
                    case .denied:
                        Text("ライブラリへのアクセスが拒否されました")
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
            .background(.white)
            .border(Color.blue, width: 8)
            .cornerRadius(10)
        }
    }
}

struct appleMusicAuthView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMusicAuthView()
            .previewLayout(.sizeThatFits)
    }
}
