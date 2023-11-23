//
//  LicenceView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/10/22.
//

import SwiftUI
import LicenseList

struct LicenceView: View {
    var body: some View {
        NavigationView {
                    LicenseListView()
                        .navigationTitle("LICENSE")
                }
    }
}

#Preview {
    LicenceView()
}
