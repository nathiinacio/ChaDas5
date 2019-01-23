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
    func readedChannels(channels: [Channel])
}

class ChannelsManager {
    
    static let instance = ChannelsManager()
    private init(){}

    var newChannelID:String?
    
//    func createChannel(story: QueryDocumentSnapshot, requester: ChannelsManagerProtocol) {
//        let channel = Channel(story: story)
//        print("channel created")
//        self.newChannelID = channel.id!
//    }
    
    func createChannel(withStory story: QueryDocumentSnapshot, completion: @escaping (Channel?, Error?) -> Void) {
        let channelsRef = FBRef.db.collection("channels")
        let channel = Channel(story: story)
        guard let channelId = channel.id else { return }
        debugPrint(channel.asDictionary)
        
        channelsRef.document(channelId).setData(channel.asDictionary) { (error) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(channel, nil)
            }
        }
    }
    
    func author(dc:QueryDocumentSnapshot) -> String{
        guard let author = dc.data()["autor"] as? String else {
            return "error retrieving author"
        }
        return author
    }
    
    var channels = [Channel]()
    
    var block = [String]()
    
    func loadChannels(requester: ChannelsManagerProtocol) {
        debugPrint("Retrieving channels...")
        let channelsRef = FBRef.db.collection("channels")
        
        self.channels = []
        let docRef = channelsRef.order(by: "lastMessageDate", descending: true)
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                debugPrint("Document error \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let currentChannel = Channel(document: document)
                    
                    guard let first = currentChannel?.firstUser?.uid else { return }
                    guard let second = currentChannel?.secondUser?.uid else { return }
                    
                    // EXCLUIR CONVERSAS COM BLOQUEADOS
                    if (first == UserManager.instance.currentUser && self.block.contains(second)) || (second == UserManager.instance.currentUser && self.block.contains(first)) {
                        FBRef.db.collection("channels").document(document.documentID).delete()
                    }
                    
                    
                    print("============= my channel: ", currentChannel?.asDictionary)
                    
                   
                    
                    self.channels.append(currentChannel!)
                }
                print("loaded channels")
                self.loadUsernames(requester: requester)
            }
        }
    }
    
    
    func preLoad(requester: ChannelsManagerProtocol) {
        self.block = []
        
        let docRef = FBRef.db.collection("users").document(
            (Auth.auth().currentUser?.uid)!).collection("block")
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Document error \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    self.block.append(document.documentID)
                }
                self.loadChannels(requester: requester)
            }
        }
    }
    
    func retriveDisplayName(withUID uid: String, completion: @escaping (String?, Error?) -> Void) {
        let usersRef = FBRef.db.collection("users")
        
        usersRef.document(uid).getDocument() { (document, error) in
            if let error = error {
                completion(nil, error)
            }
            if let username = document?.data()!["username"] as? String {
                completion(username, nil)

            } else {
                completion(nil, nil)
            }
        }
    }
    
    
    func loadUsernames(requester: ChannelsManagerProtocol) {
        /// from (https://stackoverflow.com/questions/35906568/wait-until-swift-for-loop-with-asynchronous-network-requests-finishes-executing)
        let dispatch = DispatchGroup()
        
        for channel in self.channels {
            dispatch.enter()
            guard let first = channel.firstUser?.uid else { return }
            guard let second = channel.secondUser?.uid else { return }
            
            retriveDisplayName(withUID: first) { (fUsername, error) in
                if let error = error {
                    debugPrint("======================")
                    debugPrint(#function, error.localizedDescription)
                    debugPrint("======================")
                }
                channel.firstUser?.displayName = fUsername
                
                self.retriveDisplayName(withUID: second) { (sUsername, error) in
                    if let error = error {
                        debugPrint("======================")
                        debugPrint(#function, error.localizedDescription)
                        debugPrint("======================")
                    }
                    channel.secondUser?.displayName = sUsername
                    dispatch.leave()
                }
            }
        }
        dispatch.notify(queue: .main) {
            requester.readedChannels(channels: self.channels)
        }
    }
    
}
