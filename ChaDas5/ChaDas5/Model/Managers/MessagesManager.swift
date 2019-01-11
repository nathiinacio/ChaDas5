//
//  MessagesManager.swift
//  ChaDas5
//
//  Created by Julia Rocha on 10/01/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import Foundation
import Firebase

protocol MessagesProtocol {
    
    func readedMessagesFromChannel(messages:[Message]) 
}

class MessagesManager {
    
    static let instance = MessagesManager()
    private init(){}
    
    var messages = [Message]()
    
    func loadMessages(from channel: Channel, requester: MessagesProtocol) {
        let messagesRef = FBRef.db.collection("channels").document(channel.name).collection("thread").order(by: "created")

        messagesRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Document error", err)
            } else {
                
                for document in querySnapshot!.documents {
                    guard let message = Message(document: document) else {
                        return }
                    self.messages.append(message)
                }
                requester.readedMessagesFromChannel(messages: self.messages)
            }
        }
        
    }
    
    
    
}
