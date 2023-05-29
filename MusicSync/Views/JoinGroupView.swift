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
    @State private var isActive = false
    @Binding var isTitleViewActive: Bool
    
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
                
                    
                NavigationLink(destination: AfterJoinView(isTitleViewActive: $isTitleViewActive, name: name, roomPin: roomPin),
                               isActive: $isActive){
                    Button {
                        self.isActive = true
                    } label: {
                        ButtonView(text: "グループに参加", buttonColor: roomPin == "" ? .gray : .blue)
                    }
                }
                .isDetailLink(false)
                //.disabled(viewModel.usersData.count <= 1)
                .disabled(roomPin == "")
                .padding(40)
            }
    }
}

struct joinGroupView_Previews: PreviewProvider {
    @State static var state = true
    static var previews: some View {
        JoinGroupView(isTitleViewActive: $state, name: "testUser")
    }
}
