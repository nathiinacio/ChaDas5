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
    
    func loadStories(requester:Manager) {
        self.stories = []

        let docRef = FBRef.db.collection("stories").order(by: "data", descending: true)
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Document error")
            } else {
                for document in querySnapshot!.documents {
                    guard let status = document.data()["status"] as? String else {
                        return
                    }
                    if status == "active" {
                        self.stories.append(document)
                    }
                }
                print("loaded stories")
                requester.readedStories(stories: self.stories)
            }
        }
    }
    
    
}
