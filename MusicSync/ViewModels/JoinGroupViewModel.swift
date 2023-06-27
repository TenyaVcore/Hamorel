//
//  JoinGroupViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import MusicKit
import Firebase
import FirebaseFirestoreSwift


class JoinGroupViewModel: ObservableObject {
    @Published var usersData :[UserData]
    @Published var errorMessage = ""
    @Published var isShowingAlert = false
    
    var model = FirestoreModel()
    var musicModel = AppleMusicLibraryModel()
    
    init(usersData: [UserData] = [UserData](), model: FirestoreModel = FirestoreModel(), musicModel:AppleMusicLibraryModel = AppleMusicLibraryModel()) {
        self.usersData = usersData
        self.model = model
        self.musicModel = musicModel
    }
    
    func addListener(roomPin: Int) -> ListenerRegistration {
        
        let listener = Firestore.firestore().collection("room").document(String(roomPin)).collection("insideRoom").addSnapshotListener { (querySnapshot, error) in
            guard let document = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            
            self.usersData = document.map { (queryDocumentSnapshot) -> UserData in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let id = data["id"] as? String ?? "111111"
                
                return UserData(id: id, name: name)
            }
        }
        return listener
    }
    
    
    func joinGroup(roomPin: Int, user: String) -> ListenerRegistration? {
        var listener: ListenerRegistration?
        
        musicModel.loadLibrary { [self] result  in
            switch result {
            case .success(let songs):
                model.joinRoom(roomPin: roomPin, user: user)
                model.separate(item: songs, roomPin: roomPin)
                listener = addListener(roomPin: roomPin)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isShowingAlert = true
            }
        }
        return listener
    }
    
    func exitGroup(roomPin: Int){
        model.exitRoom(roomPin: roomPin)
    }
    
}
