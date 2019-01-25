//
//  RelatoManager.swift
//  ChaDas5
//
//  Created by Julia Rocha on 19/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation
import Firebase

protocol Manager {
    
    
    func readedStories(stories:[QueryDocumentSnapshot])
    
    func readedMyStories(stories:[[QueryDocumentSnapshot]])
    
}

class RelatoManager {
    
    static let instance = RelatoManager()
    private init(){}
    var stories = [QueryDocumentSnapshot]()
    var block = [String]()
    
    func preLoad(requester: Manager) {
        self.block = []
        let currentUser = UserManager.instance.currentUser!
        let docRef = FBRef.users.document(currentUser).collection("block")
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                debugPrint("Document error \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    self.block.append(document.documentID)
                }
                self.loadStories(requester: requester, blocks: self.block)
            }
        }
    }
    
    func loadStories(requester:Manager, blocks:[String]) {
        self.stories = []

        let docRef = FBRef.stories.order(by: "data", descending: true)
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                debugPrint("Document error \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    guard let status = document.data()["status"] as? String else { return }
                    guard let author = document.data()["autor"] as? String else { return }
                    let isActive = status == "active"
                    let isBlocked = self.block.contains(author)
                    if isActive && !isBlocked{
                        self.stories.append(document)
                    }
                }
                debugPrint("loaded stories")
                requester.readedStories(stories: self.stories)
            }
        }
    }
    
}
