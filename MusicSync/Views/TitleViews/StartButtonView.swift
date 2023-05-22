//
//  StartButtonView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct StartButtonView: View {
    var body: some View {
        
        ZStack {
            Capsule()
                .fill(Color(red: 0.80, green: 0.18, blue: 0.18))
            
            Capsule()
                .fill(.red)
                .padding(16)

            Text("Start!")
                .font(.system(.title, design: .rounded, weight: .black))
                .foregroundColor(.white)
                
                
            
        }
        .frame(maxHeight: 150)
    }
}

struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView()
    }
}
