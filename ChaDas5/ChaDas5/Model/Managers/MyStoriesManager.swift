//
//  DAO.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 11/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation
import Firebase

class MyStoriesManager {
    static let instance = MyStoriesManager()
    private init(){}

    var relatosPassados = [QueryDocumentSnapshot]()
    var relatosAtuais = [QueryDocumentSnapshot]()
    
    func loadMyStories(requester:Manager) {
        emptyArrays()
        let dbRef = FBRef.db.collection("stories").order(by: "data", descending: true)
        dbRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                debugPrint("Document error \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    guard let status = document.data()["status"] as? String else {
                        return
                    }
                    guard let authorID = document.data()["autor"] as? String else {
                        return
                    }
                    if authorID == UserManager.instance.currentUser {
                        if status == "active" {
                            self.relatosAtuais.append(document)
                        } else {
                            self.relatosPassados.append(document)
                        }
                }
                requester.readedMyStories(stories: [self.relatosPassados, self.relatosAtuais])
            }
        }
    }
    }
    
    func emptyArrays() {
        self.relatosAtuais = []
        self.relatosPassados = []
    }
    
    
    
}

