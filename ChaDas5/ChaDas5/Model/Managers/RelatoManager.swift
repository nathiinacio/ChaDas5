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
    
    func loadStories(requester:Manager, blocks:[String]) {
        self.stories = []

        let docRef = FBRef.db.collection("stories").order(by: "data", descending: true)
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                debugPrint("Document error \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    guard let status = document.data()["status"] as? String else {
                        return
                    }
                    
                    guard let author = document.data()["autor"] as? String else {
                        return
                    }
                    if status == "active" && !self.block.contains(author) {
                        self.stories.append(document)
                    }
                }
                print("loaded stories")
                requester.readedStories(stories: self.stories)
            }
        }
    }
    
    func preLoad(requester: Manager) {
        self.block = []
        
        let docRef = FBRef.db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("block")
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                debugPrint("Document error \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    print("==============", document.documentID)
                    self.block.append(document.documentID)
                }
                print("===============", self.block)
                self.loadStories(requester: requester, blocks: self.block)
            }
        }
    }
    
    
    
    
}
