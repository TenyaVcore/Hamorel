//
//  EnterRoomPinView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/02.
//

import SwiftUI

struct EnterRoomPinView: View {
    @State var roomPin = "000000"
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle(Color("Color_primary"))
                    .cornerRadius(20)
                    .frame(height: 200)
                
                VStack{
                    Text("Room Pinを入力")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text(roomPin)
                        .foregroundStyle(Color.black.opacity(0.8))
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .background(Color.white)
                }
            }
            
            NavigationLink(value: NavigationLinkItem.playlist(roomPin)){
                ButtonView(text: "次へ", buttonColor: Color("Color_primary"))
            }

            
            
            Button(action: {
                path.removeLast()
            }, label: {
                ButtonView(text: "roomを解散する", textColor: .black, buttonColor: Color("Color_secondary"))
            })
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    return EnterRoomPinView(path: $path)
}
