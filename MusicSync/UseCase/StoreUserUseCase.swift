//
//  StoreUserUseCase.swift
//  MusicSync
//
//  Created by 田川展也 on 12/25/R6.
//

final class StoreUserUseCase: Sendable {
    static let shared = StoreUserUseCase()
    private init() {}

    let repo = UserRepository()

    // FIXME: firebaseへ保存する
    func storeUser(user: UserData) {
        repo.storeUser(user: user)
    }

    func fetchUser() -> UserData {
        let user = repo.fetchUser()
        return user ?? UserData(id: "000000", name: "ゲストユーザー")
    }
}
