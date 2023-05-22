//
//  Protocols.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit

protocol LibraryGetting {
    func loadLibraryAsync(limit: Int) async throws -> MusicItemCollection<Song>
}

