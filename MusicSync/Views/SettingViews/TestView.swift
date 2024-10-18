//
//  TestView.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/10/05.
//

import SwiftUI
import MusicKit

struct TestView: View {
    @State var song: Song!

    var body: some View {
        Text("title: " + song.title)
        Text("artist: " + song.artistName)

        List {
            
        }
    }
}

#Preview {
    TestView()
}
