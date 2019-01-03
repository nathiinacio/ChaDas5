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
    
    func createChannel(requester:ChannelsManagerProtocol) {
        let channel = Channel(name: "channel")
        let channelRef = FBRef.db.collection("channels")
        channelRef.addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
        print("channel created")
        print(channel.id!)
        self.newChannelID = channel.id!
        requester.addToMyChannels()
    }
    
    
    func author(dc:QueryDocumentSnapshot) -> String{
        return dc.data()["autor"] as! String
    }
    
    var channels = [QueryDocumentSnapshot]()
    
    func loadChannels(requester:ChannelsManagerProtocol) {
        let docRef = FBRef.db.collection("users").document((UserManager.instance.currentUser?.uid)!).collection("myChannels")
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
