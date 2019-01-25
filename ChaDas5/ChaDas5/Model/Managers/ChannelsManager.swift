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
    var channels = [Channel]()
    var block = [String]()


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

    
    func loadChannels(requester: ChannelsManagerProtocol) {
        debugPrint("Retrieving channels...")
        let channelsRef = FBRef.channels
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
                    
                    let isMyChannel = first == UserManager.instance.currentUser || second == UserManager.instance.currentUser
                    let isBlocked = self.block.contains(first) || self.block.contains(second)
                    
                    if isMyChannel && !isBlocked {
                        self.channels.append(currentChannel!)
                    } else if isMyChannel && isBlocked {
                        FBRef.channels.document((currentChannel?.id)!).delete()
                    }
                }
                debugPrint("loaded channels")
                self.loadUsernames(requester: requester)
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
            
            self.retriveDisplayName(withUID: first) { (fUsername, error) in
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
    
    func retriveDisplayName(withUID uid: String, completion: @escaping (String?, Error?) -> Void) {
        FBRef.users.document(uid).getDocument() { (document, error) in
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
    
}
