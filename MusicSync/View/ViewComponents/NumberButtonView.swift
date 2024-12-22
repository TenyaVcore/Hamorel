//
//  NumberButtonView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/19.
//

import SwiftUI

struct NumberButtonView: View {
    var text: String

    var body: some View {
       Text(text)
            .padding(.horizontal, 1)
            .frame(width: 123, height: 56, alignment: .center)
            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
            .cornerRadius(5)
            .shadow(color: Color(red: 0.54, green: 0.54, blue: 0.55), radius: 0, x: 0, y: 1)
    }
}

#Preview {
    NumberButtonView(text: "1")
}
