//
//  ButtonView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var buttonColor: Color
    
    var body: some View {
        ZStack{
            
            Capsule()
                .fill(buttonColor)
            
            Text(text)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: 300, maxHeight: 60)
        
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "ボタン", buttonColor: .blue)
    }
}
