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
    
}

class RelatoManager {
    
    static let instance = RelatoManager()
    private init(){}
    
    var stories = [QueryDocumentSnapshot]()
    
    func loadStories(requester:Manager) {
        let docRef = FBRef.db.collection("Feed")
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Document error")
            } else {
                for document in querySnapshot!.documents {
                    self.stories.append(document)
                }
                print("loaded stories")
                requester.readedStories(stories: self.stories)
            }
        }
    }
    
    
    
}
