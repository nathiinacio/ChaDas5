//
//  Firebase.swift
//  ChaDas5
//
//  Created by Julia Rocha on 10/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Firebase


class FBRef {
    static var db:Firestore!
    
    static var channels = FBRef.db.collection("channels")
    static var users = FBRef.db.collection("users")
    static var stories = FBRef.db.collection("stories")
    static var analise = FBRef.db.collection("analise")
    
}
