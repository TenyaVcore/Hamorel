//
//  FirebaseAuthModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import Firebase
import SwiftUI

struct FirebaseAuthModel {

    func createUser(email: String, name: String, password: String, completion: @escaping (Error?) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                let request = user.createProfileChangeRequest()
                request.displayName = name
                request.commitChanges { error in
                    if error == nil {
                        user.sendEmailVerification { error  in
                            // メールアドレスに確認メールが送信。
                            if error == nil {
                                // 成功
                                completion(error)
                            }
                        }
                    } else {
                        print("リクエスト送信失敗 error:\(error!)")
                        completion(error)
                    }
                }
            } else {
                print("ユーザ作成失敗 error:\(error!)")
                completion(error)
            }
        }
    }

    func loginAsGuest(completion: @escaping (Error?) -> Void) {
        Auth.auth().signInAnonymously { result, error in
            if let user = result?.user {
                let uid = user.uid
                print("ゲストログイン成功")
                print("ゲストID: \(uid)")
            } else {
                print("ゲストログイン失敗")
            }
            completion(error)
        }
    }

    func changeUserName(newName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        changeRequest?.commitChanges { error in
            print(error?.localizedDescription ?? "error" )
        }
    }

    func loginAsGuestAsync() async throws {
        try await Auth.auth().signInAnonymously()
    }

}
