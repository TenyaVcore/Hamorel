//
//  HowToView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/07/05.
//

import SwiftUI

struct HowToView: View {
    var body: some View {
        
        TabView{
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Color(.yellow)
            
            Text("3")
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct HowToView_Previews: PreviewProvider {
    static var previews: some View {
        HowToView()
    }
}
