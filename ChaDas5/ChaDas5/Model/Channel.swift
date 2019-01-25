//
//  Channel.swift
//  ChaDas5
//
//  Created by Nathalia Inacio on 29/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import FirebaseFirestore
import UserNotifications

struct ChannelUser {
    var uid: String
    var displayName: String?
}

class Channel {
  
    var id: String?
    var firstUser: ChannelUser?
    var created: String?
    var secondUser: ChannelUser?
    var lastMessageDate: String?
  
    init(story: QueryDocumentSnapshot) {
        let currentUser = UserManager.instance.currentUser!
        self.firstUser = ChannelUser(uid: (currentUser), displayName: nil)
        self.created = Date().keyString
        self.id = self.channelID
        self.secondUser = ChannelUser(uid: self.author(with: story), displayName: nil)
        self.lastMessageDate = created
    }
  
    init?(document: QueryDocumentSnapshot) {
        var data = document.data()
        id = document.documentID
        guard let fUser = data["firstUser"] as? String else {
            debugPrint("Error in first user")
            return
        }
        guard let sUser = data["secondUser"] as? String else {
            debugPrint("Error in first user")
            return
        }
        guard let createdDate = data["created"] as? String else {
            debugPrint("Error in created date")
            return
        }
        
        self.firstUser = ChannelUser(uid: fUser, displayName: nil)
        self.secondUser = ChannelUser(uid: sUser, displayName: nil)
        self.created = createdDate
    }
    
    init?(
        document: DocumentReference,
        completion: @escaping (Error?) -> Void) {
        document.getDocument { (snapshot, err) in
            if let error = err {
                completion(error)
            }
            let currentUser = UserManager.instance.currentUser!
            var data = snapshot?.data()
            self.id = document.documentID
            guard let autor = data!["autor"] as? String else { return }
            
            self.firstUser = ChannelUser(uid: currentUser, displayName: nil)
            self.secondUser = ChannelUser(uid: autor, displayName: nil)
            self.created = Date().keyString
            self.lastMessageDate = self.created
            completion(nil)
        }
        
    }
    
    func add(message:Message) {
        guard let id = self.id else {
            print("error saving message")
            return}
        let channelMessagesRef = FBRef.channels.document(id).collection("thread")
        channelMessagesRef.addDocument(data: message.representation) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("saved message")
            }
        }
        self.lastMessageDate = message.sentDate.keyString
        FBRef.channels.document(id).updateData(["lastMessageDate" : self.lastMessageDate])
    }
    
  }

extension Channel {
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["firstUser"] = self.firstUser?.uid
        result["created"] = self.created
        result["secondUser"] = self.secondUser?.uid
        result["lastMessageDate"] = self.lastMessageDate
        return result
    }
    
    var channelID:String {
        guard let first = self.firstUser else {
            return "error_in_first"
        }
        guard let created = self.created else {
            return "data_non_avaliable"
        }
        return first.uid+"|"+created
    }

    func author(with story:QueryDocumentSnapshot) -> String{
        guard let author = story.data()["autor"] as? String else {
            return "error retrieving author"
        }
        return author
    }

}
