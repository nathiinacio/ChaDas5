//
//  StoryScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase

class StoryScreen: UIViewController, ChannelsManagerProtocol {
    func readedChannels(channels: [QueryDocumentSnapshot]) {
        print("not here too")
    }
    
    
    
    func addToMyChannels() {
        let id = UserManager.instance.currentUser?.uid
   
        let channelID = ChannelsManager.instance.newChannelID!
    FBRef.db.collection("users").document(id!).collection("myChannels").addDocument(data: ["ID":channelID])
        
    FBRef.db.collection("users").document(ChannelsManager.instance.author(dc: self.selectedStory!)).collection("myChannels").addDocument(data: ["ID":channelID])
        
    }
    
    
    var selectedStory:QueryDocumentSnapshot?

    
    //outlets
    
    @IBOutlet weak var chatButton: UIButton!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    @IBOutlet weak var storyTextView: UITextView!
    @IBAction func chatButton(_ sender: Any) {
        ChannelsManager.instance.createChannel(requester: self)
    }
    
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        self.storyTextView.text = self.selectedStory?.data()["conteudo"] as! String
        
        if self.selectedStory?.data()["autor"] as? String == UserManager.instance.currentUser?.uid {
            chatButton.isEnabled = false
            
        }
    }
    

    
}
