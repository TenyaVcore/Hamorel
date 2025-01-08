//
//  NavigationLinkItem.swift
//  MusicSync
//
//  Created by 田川展也 on 12/25/R6.
//

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
    case license
    case debug
}
