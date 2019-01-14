//
//  Channel.swift
//  ChaDas5
//
//  Created by Nathalia Inacio on 29/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import FirebaseFirestore

class Channel {
  
    var id: String?
    let name: String
    var firstUser:String?
    var created:String?
    var secondUser:String?
    var lastMessageDate:String?
  
    init(name: String, story: QueryDocumentSnapshot) {
        self.name = name
        self.firstUser = (UserManager.instance.currentUser)
        self.created = Date().keyString
        self.id = self.channelID
        self.secondUser = ChannelsManager.instance.author(dc: story)
        self.lastMessageDate = created
        let newDoc = FBRef.db.collection("channels").document(self.channelID).setData(self.asDictionary)
    }
  
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["ID"] as? String else {
            return nil
            
        }
        id = document.documentID
        self.name = name
        let addicData = name.split(separator: "|")
        self.firstUser = String(addicData[0] ?? "")
        self.created = String(addicData[1] ?? "")
    }
    
    
    
    
    func add(message:Message) {
        //SALVA A MENSAGEM NO CHANNEL
        guard let id = self.id else {
            print("error saving message")
            return}
        let channelMessagesRef = FBRef.db.collection("channels").document(name).collection("thread")
        channelMessagesRef.addDocument(data: message.representation) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("saved message")
            }
        }
        self.lastMessageDate = message.sentDate.keyString
        FBRef.db.collection("channels").document(name).updateData(["lastMessageDate" : self.lastMessageDate])
    }
    
  }

extension Channel: DatabaseRepresentation {
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["firstUser"] = self.firstUser
        result["name"] = self.name
        result["created"] = self.created
        result["secondUser"] = self.secondUser
        result["lastMessageDate"] = self.lastMessageDate
        return result
    }
    
    var channelID:String {
        guard let first = self.firstUser else {
            return "user_error"
        }
        guard let created = self.created else {
            return "data_non_avaliable"
        }
        return first+"|"+created
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
