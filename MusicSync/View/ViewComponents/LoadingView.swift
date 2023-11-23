//
//  LoadingView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var numberOfDots = 0

    let maxDots = 4
    var message: String

    var body: some View {
        ZStack {
            Color("color_primary")
                .ignoresSafeArea()

            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(isAnimating ? 3600 : 0))
                    .animation(
                        .linear(duration: 30).repeatForever(autoreverses: false),
                        value: isAnimating
                    )

                HStack(spacing: 0) {
                    Text(message)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    ForEach(0 ..< numberOfDots, id: \.self) { _ in
                        Text(".")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }
                .onAppear {
                    isAnimating = true
                    _ = withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        Timer.scheduledTimer(withTimeInterval: 3 / Double(maxDots), repeats: true) { _ in
                            numberOfDots = (numberOfDots + 1) % (maxDots + 1)
                        }
                    }
                }
            }
        }
    }
}

struct loadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "ローディング中")
    }
}
