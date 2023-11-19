//
//  EnterRoomPinViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/19.
//

import Foundation

@MainActor
class EnterRoomPinViewModel: ObservableObject {
    @Published var roomPin = ""
    
    func pushNumButton(num: Int) {
        if roomPin.count < 6 {
            roomPin.append(String(num))
        }
    }
    
    func deleteNum() {
        if !roomPin.isEmpty{
            roomPin.removeLast()
        }
    }
}
