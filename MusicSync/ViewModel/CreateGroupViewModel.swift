//
//  CreateGroupViewModel.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI
import Combine
import MusicKit
import Firebase
import FirebaseFirestoreSwift


class CreateGroupViewModel: ObservableObject {
    
    @Published var usersData :[UserData]
    @Published var errorMessage = ""
    @Published var pubRoomPin = 0
    
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
                
                return UserData(name: name)
            }
        }
        return listener
    }
    
    
    func createGroup(userName: String) -> (ListenerRegistration?, Int) {
        var listener: ListenerRegistration?
        var roomPin: Int = 0
        
        musicModel.loadLibrary { [self] result  in
            switch result {
            case .success(let songs):
                roomPin = model.createRoom(createMiss: 0, user: userName)
                model.separate(item: songs, roomPin: roomPin)
                listener = addListener(roomPin: roomPin)
                
                pubRoomPin = roomPin
                LoadingControl.shared.hideLoading()
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
       
        return (listener , roomPin)
    }
    
    func exitGroup(roomPin: Int){
        model.exitRoom(roomPin: roomPin)
    }
    
}
