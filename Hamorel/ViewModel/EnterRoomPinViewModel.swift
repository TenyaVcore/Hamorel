//
//  EnterRoomPinViewModel.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/11/19.
//

import SwiftUICore

@MainActor
class EnterRoomPinViewModel: ObservableObject {
    @Published var roomPin = ""

    func onTappedNumButton(num: Int) {
        if roomPin.count < 6 {
            roomPin.append(String(num))
        }
    }

    func onTappedDeleteButton() {
        if !roomPin.isEmpty {
            roomPin.removeLast()
        }
    }
}
