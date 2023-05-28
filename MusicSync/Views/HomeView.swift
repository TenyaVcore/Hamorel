//
//  HomeView.swift
//  MusicSync
//
//  Created by 田川展也 on R 5/05/22.
//

import SwiftUI

import SwiftUI
import MusicKit
import Firebase
import FirebaseFirestoreSwift

struct HomeView: View {
    var Name:String
    
    @State var isLoading = false
    
    
    let libraryModel = AppleMusicLibraryModel()
    let firestoreModel = FirestoreModel()
    //テスト
    
    func fetchUserDataTest(completion: @escaping (Result<MusicItemCollection<Song>, Error>) -> Void) {
        var usersSongs: MusicItemCollection<Song> = MusicItemCollection<Song>()
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let doc = Firestore.firestore().collection("room").document(String(239006)).collection("insideRoom").document("A4700E05-9D3A-44E2-AE0F-04B99B1E583F").collection("songs")
        
        for i in 1...15 {
            dispatchGroup.enter() // dispatchGroupに入場
            
            dispatchQueue.async(group: dispatchGroup) {
                doc.document(String(i)).getDocument(as: UserSongs.self) { result in
                    switch result {
                    case .success(let data):
                        usersSongs += data.songs
                        
                    case .failure(let error):
                        print("error: \(error)")
                    }
                    
                    dispatchGroup.leave() // dispatchGroupから退出
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(usersSongs))
        }
    }

    //テスト終わり
    
    var body: some View {
            
        ZStack{
            
            if isLoading{LoadingView()}
            
            VStack{
                
                Text(Name)
                    .font(.system(size: 25, weight: .bold, design: .default))
                
                NavigationLink(destination: CreateGroupView(name: Name),
                               label: {GroupButtonView(text: "グループを作成", buttonColor: .blue)})
                    .padding(40)
                NavigationLink(destination: JoinGroupView(name: Name),
                               label: {GroupButtonView(text: "グループに参加", buttonColor: .red)})
                
                
                //テスト
                
                
//                Button("download") {
//
//                    firestoreModel.downloadData(roomPin: 239006, usersData: [UserData(id: "A4700E05-9D3A-44E2-AE0F-04B99B1E583F", name: "なつみかん")]) { result in
//                        switch result{
//                        case .success(let songs):
//                            print(songs)
//                            let addSong = songs[0]
//
//                            Task{try await MusicLibrary.shared.createPlaylist(name: "test Playlist", items: addSong )}
//
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//
//                }.padding(60)
                
                //テスト終わり
            }
        }
    }
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(Name: "preview name")
    }
}
