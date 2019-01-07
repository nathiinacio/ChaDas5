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
  
  init(name: String) {
    self.name = name
    let newDoc = FBRef.db.collection("channels").addDocument(data: self.representation)
    self.id = newDoc.documentID
  }
  
//  init?(document: QueryDocumentSnapshot) {
//    let data = document.data()
//
//    guard let name = data["name"] as? String else {
//      return nil
//    }
//
//    id = document.documentID
//    self.name = name
//  }
  
}

extension Channel: DatabaseRepresentation {
  
  var representation: [String : Any] {
    var rep = ["name": name]
    
    if let id = id {
      rep["id"] = id
    }
    
    return rep
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
