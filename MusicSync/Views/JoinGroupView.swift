//
//  JoinGroupView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

import SwiftUI

struct JoinGroupView: View {
    @State private var roomPin:String = ""
    
    var name: String
    
    var body: some View {
      
            VStack{
                TextField("roomPinを入力", text: $roomPin)
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .frame(minWidth: 170)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(.red,lineWidth: 3)
                    )
                    .padding(.horizontal, 160)
                
                NavigationLink("join group!", destination: AfterJoinView(name: name, roomPin: roomPin))
                    .disabled(roomPin == "")
                    .padding(40)
            }
    }
}

struct joinGroupView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGroupView(name: "testUser")
    }
}
