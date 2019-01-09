//
//  Channel.swift
//  ChaDas5
//
//  Created by Nathalia Inacio on 29/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import FirebaseFirestore

struct Channel {
  
    var id: String?
    let name: String
    var firstUser:String?
    var created:String?
  
    init(name: String) {
        self.name = name
        self.firstUser = (UserManager.instance.currentUser?.uid)
        self.created = Date().keyString
        self.id = self.channelID
        let newDoc = FBRef.db.collection("channels").document(self.channelID).setData(self.asDictionary)
    }
  
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["ID"] as? String else {
            return nil
            
        }
        id = document.documentID
        self.name = name
        guard let created = data["created"] as? String else {
            return nil
        }
        self.created = created
    }
  }

extension Channel: DatabaseRepresentation {
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["firstUser"] = self.firstUser
        result["name"] = self.name
        result["created"] = self.created
        return result
    }
    
    var channelID:String {
        guard let first = self.firstUser else {
            return "user_error"
        }
        guard let created = self.created else {
            return "data_non_avaliable"
        }
        return first+created
    }
    
  
}

extension Channel: Comparable {
  
  static func == (lhs: Channel, rhs: Channel) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Channel, rhs: Channel) -> Bool {
    return lhs.name < rhs.name
  }

}
