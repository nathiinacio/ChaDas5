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
    
    func readedMyStories(stories:[QueryDocumentSnapshot])
    
}

class RelatoManager {
    
    static let instance = RelatoManager()
    private init(){}
    
    var stories = [QueryDocumentSnapshot]()
    
    var myCurrentStories = [QueryDocumentSnapshot]()
    
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
    
    func loadMyCurrentStories(requester:Manager) {
        let userRef = FBRef.db.collection("user").document((UserManager.instance.currentUser?.uid)!).collection("myStories")
        userRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Document error")
            } else {
                for document in querySnapshot!.documents {
                    self.myCurrentStories.append(document)
                }
                print("loaded my stories")
                requester.readedMyStories(stories: self.myCurrentStories)
            }
        }
    }
    
    
    
}
