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
    var firstUser:String?
    var created:String?
    var secondUser:String?
    var lastMessageDate:String?
  
    init(story: QueryDocumentSnapshot) {
        self.firstUser = (UserManager.instance.currentUser)
        self.created = Date().keyString
        self.id = self.channelID
        self.secondUser = ChannelsManager.instance.author(dc: story)
        self.lastMessageDate = created
        let newDoc = FBRef.db.collection("channels").document(self.channelID).setData(self.asDictionary)
    }
  
    init?(document: QueryDocumentSnapshot) {
        var data = document.data()
        id = document.documentID
        data["firstUser"] = self.firstUser
        data["secondUser"] = self.secondUser
        data["created"] = self.created
    }
    
    
    
    
    func add(message:Message) {
        //SALVA A MENSAGEM NO CHANNEL
        guard let id = self.id else {
            print("error saving message")
            return}
        let channelMessagesRef = FBRef.db.collection("channels").document(id).collection("thread")
        channelMessagesRef.addDocument(data: message.representation) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("saved message")
            }
        }
        self.lastMessageDate = message.sentDate.keyString
        FBRef.db.collection("channels").document(id).updateData(["lastMessageDate" : self.lastMessageDate])
    }
    
  }

extension Channel: DatabaseRepresentation {
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["firstUser"] = self.firstUser
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
