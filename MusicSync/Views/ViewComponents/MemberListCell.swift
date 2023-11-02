//
//  MemberListCell.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/02.
//

import SwiftUI

struct MemberListCell: View {
    let name:String
    
    var body: some View {
        HStack{
            Circle()
                .foregroundStyle(Color.gray)
                .frame(width: 40, height: 40)
                .padding(.horizontal, 15)
            
            Text(name)
                .bold()
            
            Spacer()
            
            Button {
                
            } label: {
                Text("削除")
                    .foregroundStyle(Color.red)
                    .padding(7)
                    .border(Color.red, width: 2)
                    .padding(.trailing, 15)
            
                    
            
            }

            
        }
    }
}

#Preview {
    MemberListCell(name: "ユーザー名")
}
