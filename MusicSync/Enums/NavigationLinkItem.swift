//
//  NavigationItem.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/11/02.
//

import Foundation

enum NavigationLinkItem: Hashable {
    case home
    case create
    case join(String)
    case enter
    case playlist(String)
    case setting
    case login
    case passwordReset
    case register
    case provision
    case licence
}
