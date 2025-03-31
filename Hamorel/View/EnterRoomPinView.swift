//
//  EnterRoomPinView.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/11/02.
//

import SwiftUI

struct EnterRoomPinView: View {
    @StateObject private var viewModel = EnterRoomPinViewModel()
    @EnvironmentObject private var router: Router

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color("color_primary"))
                    .cornerRadius(20)
                    .frame(height: 200)

                VStack {
                    Text("Room Pinを入力")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()

                    Text(viewModel.roomPin)
                        .frame(width: 150, height: 20)
                        .foregroundStyle(Color.black.opacity(0.8))
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .background(Color.white)
                }
            }
            .padding()

            ForEach(1...3, id: \.self) { row in
                HStack {
                    ForEach(row * 3 - 2...row * 3, id: \.self) { num in
                        Button(action: {
                            viewModel.onTappedNumButton(num: num)
                        }, label: {
                            NumberButtonView(text: String(num))
                        })
                    }
                }
            }

            HStack {
                Button(action: {
                    viewModel.onTappedDeleteButton()
                }, label: {
                    DeleteButtonView()
                })

                Button(action: {
                    viewModel.onTappedNumButton(num: 0)
                }, label: {
                    NumberButtonView(text: String(0))
                })

                Button(action: {
                    viewModel.onTappedDeleteButton()
                }, label: {
                    DeleteButtonView()
                })
            }

            NavigationLink(value: NavigationLinkItem.join(viewModel.roomPin)) {
                ButtonView(text: "ルームに参加する", buttonColor: Color("color_primary"))
            }
            .padding(.top, 10)

            Button(action: {
                router.pop()
            }, label: {
                ButtonView(text: "戻る", textColor: .black, buttonColor: Color("color_secondary"))
            })
            .padding(.horizontal, 8)
        }
    }
}

#Preview {
    return EnterRoomPinView()
}
