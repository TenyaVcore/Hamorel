//
//  JoinRoomError.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/19.
//

import Foundation

enum JoinRoomError: Error {
    case roomNotFound
    case roomIsFull
    case unknownError(Error)

    var localizedDescription: String {
        switch self {
        case .roomNotFound: return "room Pinが存在しません"
        case .roomIsFull: return "ルームが満員です"
        case .unknownError(let error): return "予期せぬエラーが発生しました。詳細: （\(error)）"
        }
    }
}
