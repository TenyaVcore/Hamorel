//
//  UserData.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/19.
//

import UIKit
import MusicKit

// firestoreに保存するデータモデル
struct UserData: Identifiable, Codable, Hashable {
    var id: String = UIDevice.current.identifierForVendor!.uuidString
    var name: String
}

// 楽曲情報用のモデル
struct UserSongs: Codable {
    var songs: MusicItemCollection<Song>
}
