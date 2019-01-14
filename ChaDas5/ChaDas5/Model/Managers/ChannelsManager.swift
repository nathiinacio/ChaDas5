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
    
    
    func addToMyChannels()
    
    func readedChannels(channels:[QueryDocumentSnapshot])
    
}

class ChannelsManager {
    
    static let instance = ChannelsManager()
    private init(){}

    var newChannelID:String?
    
    func createChannel(story: QueryDocumentSnapshot,requester:ChannelsManagerProtocol) {
        let channel = Channel(name: "channel", story: story)
        let channelRef = FBRef.db.collection("channels")
        print("channel created")
        print(channel.id!)
        self.newChannelID = channel.id!
        requester.addToMyChannels()
    }
    
    
    func author(dc:QueryDocumentSnapshot) -> String{
        guard let author = dc.data()["autor"] as? String else {
            return "error retrieving author"
        }
        return author
    }
    
    var channels = [QueryDocumentSnapshot]()
    
    func loadChannels(requester:ChannelsManagerProtocol) {
        self.channels = []
        let docRef = FBRef.db.collection("users").document((UserManager.instance.currentUser)!).collection("myChannels")
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Document error")
            } else {
                for document in querySnapshot!.documents {
                    self.channels.append(document)
                }
                print("loaded channels")
                requester.readedChannels(channels: self.channels)
            }
        }
    }
    
   
}
