//
//  AppleMusicAuthView.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct AppleMusicAuthView: View {

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.leading, 5)

                Text("Apple Music Libraryへの\nアクセス権限が必要です。")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(5)
            }

            Divider()

            VStack {
                    VStack {
                        Text("アプリでAppleMusicのライブラリ情報を取得するため、設定からメディアとAppleMusicへのアクセスを許可してください。")
                    }
            }.padding()

            Image("apple_music_auth")
                .resizable()
                .scaledToFit()
                .padding(25)

            Button {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            } label: {
                ButtonView(text: "次へ",
                           buttonColor: Color("color_primary"))
                    .padding(25)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct AppleMusicAuthView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMusicAuthView()
            .previewLayout(.sizeThatFits)
    }
}
