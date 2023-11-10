//
//  CreateRoomError.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/09.
//

import Foundation

enum CreateRoomError: Error {
    case canNotFindRoomPin10Times
    case otherError(Error)
    
    var localizedDescription: String {
        switch self {
        case .canNotFindRoomPin10Times: return "room Pinの作成に10回失敗しました"
        case .otherError(let error): return "予期せぬエラーが発生しました。詳細: （\(error)）"
            
        }
    }
}
