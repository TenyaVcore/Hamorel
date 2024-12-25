//
//  UserRepository.swift
//  MusicSync
//
//  Created by 田川展也 on 12/25/R6.
//

import Foundation.NSJSONSerialization

struct UserRepository: Sendable {
    func storeUser(user: UserData) {
        UserDefaults.standard.set(try? JSONEncoder().encode(user), forKey: "user")
    }

    func fetchUser() -> UserData? {
        let data = UserDefaults.standard.data(forKey: "user")
        if let data = data, let user = try? JSONDecoder().decode(UserData.self, from: data) {
            return user
        } else {
            return nil
        }
    }
}
