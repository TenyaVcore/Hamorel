//
//  MemberListCell.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/11/02.
//

import SwiftUI

struct MemberListCell: View {
    let name: String

    var body: some View {
        HStack {
//            Circle()
//                .foregroundStyle(Color.gray)
//                .frame(width: 35)
//                .padding(.horizontal, 15)
//                .padding(.vertical, 4)

            Text(name)
                .bold()
                .padding()

            Spacer()

        }
        .padding(.horizontal, 1)
    }
}

#Preview {
    MemberListCell(name: "ユーザー名")
}
