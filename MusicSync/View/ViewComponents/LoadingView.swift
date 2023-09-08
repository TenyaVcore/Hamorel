//
//  LoadingView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct LoadingView: View {
    @State var isAnimating = false
    var text: String
    
    var body: some View {
        ZStack{
            Color("BackGroundColor")
                .edgesIgnoringSafeArea(.all)
                .disabled(true)
            
            VStack{
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 2).repeatForever(autoreverses: false),
                        value: isAnimating)
                    .onAppear{
                        isAnimating = true
                    }
                
                Text(text)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(50)
            
            
        }
    }
}


class LoadingControl: ObservableObject {
    static let shared = LoadingControl()
    
    @Published var isLoading = false
    
    func showLoading(){
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
    }
}

struct loadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: "Now loading...")
    }
}
