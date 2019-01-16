//
//  ChannelsManager.swift
//  ChaDas5
//
//  Created by Julia Rocha on 03/01/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import Foundation
import Firebase

protocol ChannelsManagerProtocol {
    
    
    func readedChannels(channels:[QueryDocumentSnapshot])
    
}

class ChannelsManager {
    
    static let instance = ChannelsManager()
    private init(){}

    var newChannelID:String?
    
    func createChannel(story: QueryDocumentSnapshot,requester:ChannelsManagerProtocol) {
        let channel = Channel(story: story)
        let channelRef = FBRef.db.collection("channels")
        print("channel created")
        self.newChannelID = channel.id!
    }
    
    
    func author(dc:QueryDocumentSnapshot) -> String{
        guard let author = dc.data()["autor"] as? String else {
            return "error retrieving author"
        }
        return author
    }
    
    var channels = [QueryDocumentSnapshot]()
    
    func loadChannels(requester:ChannelsManagerProtocol) {
        debugPrint("Retrieving channels...")
        self.channels = []
        let docRef = FBRef.db.collection("channels").order(by: "lastMessageDate", descending: true)
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Document error")
            } else {
                for document in querySnapshot!.documents {
                    
                    guard let first = document.data()["firstUser"] as? String else {
                        debugPrint("error in first user")
                        return }
                    guard let second = document.data()["secondUser"] as? String else {
                        debugPrint("error in second user")
                        return }
                    if first == Auth.auth().currentUser?.uid || second == Auth.auth().currentUser?.uid {
                        self.channels.append(document)
                    }
                }
                print("loaded channels")
                requester.readedChannels(channels: self.channels)
            }
        }
    }
    
   
}
