//
//  LoadingView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .disabled(true)
            
            ProgressView("Now loading...")
                .padding(80)
                .background(Color(uiColor: .lightGray))
                .cornerRadius(12)
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
        LoadingView()
    }
}
