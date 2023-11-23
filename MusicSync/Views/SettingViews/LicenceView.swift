//
//  LicenceView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/23.
//

import SwiftUI
import LicenseList

struct LicenceView: View {
    var body: some View {
        List(Library.libraries, id: \.name) { library in
            Text(library.name)
        }
        .navigationTitle("ライセンス一覧")
    }
}

#Preview {
    LicenceView()
}
