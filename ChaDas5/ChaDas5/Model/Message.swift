//
//  ChannelsManager.swift
//  ChaDas5
//
//  Created by Julia Rocha on 03/01/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
    
    var kind: MessageKind
    let id: String?
    let content: String
    let sentDate: Date
    let sender: Sender
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    
    init(content: String) {
        sender = Sender(id: (UserManager.instance.currentUser)!, displayName: AppSettings.displayName)
        self.content = content
        sentDate = Date()
        id = nil
        kind = .text(content)
    }
    
    
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        
        guard let sentDate = (data["created"] as? Timestamp)?.dateValue() else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            self.kind = .text(content)
        } else {
            return nil
        }
    }
    
}

extension Message: DatabaseRepresentation {
    var asDictionary: [String : Any] {
        return [:]
    }
    
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.id,
            "senderName": sender.displayName,
            "content":content
        ]
        return rep
    }
    
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

