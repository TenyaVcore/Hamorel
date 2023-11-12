//
//  GroupButtonView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct GroupButtonView: View {
    var text: String
    var buttonColor: Color
    var edge: CGFloat = 20
    var buttonWidth: CGFloat = 300
    var buttonHeight: CGFloat = 100
    var lineOffset: CGFloat = 10

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: edge, y: 0))
                path.addLine(to: CGPoint(x: buttonWidth - edge, y: 0))
                path.addLine(to: CGPoint(x: buttonWidth, y: edge))
                path.addLine(to: CGPoint(x: buttonWidth, y: buttonHeight - edge))
                path.addLine(to: CGPoint(x: buttonWidth - edge, y: buttonHeight))
                path.addLine(to: CGPoint(x: edge, y: buttonHeight))
                path.addLine(to: CGPoint(x: 0, y: buttonHeight - edge))
                path.addLine(to: CGPoint(x: 0, y: edge))
            }
            .fill(buttonColor)

            Path { path in
                path.move(to: CGPoint(x: edge + lineOffset, y: lineOffset))
                path.addLine(to: CGPoint(x: buttonWidth - edge - lineOffset, y: lineOffset))
                path.addLine(to: CGPoint(x: buttonWidth - lineOffset, y: edge + lineOffset))
                path.addLine(to: CGPoint(x: buttonWidth - lineOffset, y: buttonHeight - edge - lineOffset))
                path.addLine(to: CGPoint(x: buttonWidth - edge - lineOffset, y: buttonHeight - lineOffset))
                path.addLine(to: CGPoint(x: edge + lineOffset, y: buttonHeight - lineOffset))
                path.addLine(to: CGPoint(x: lineOffset, y: buttonHeight - edge - lineOffset))
                path.addLine(to: CGPoint(x: lineOffset, y: edge + lineOffset))
                path.closeSubpath()
            }
            .stroke(lineWidth: 1.5)
            .foregroundColor(.white)
            .opacity(0.7)

        }
        .overlay(Text(text)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white))
        .frame(width: 300, height: 100)

    }
}

struct GroupButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GroupButtonView(text: "グループボタン", buttonColor: .red)
    }
}
