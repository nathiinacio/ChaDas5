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
    
    
    @IBAction func archiveButton(_ sender: Any) {
        guard let id = selectedStory?.documentID else {
            return
        }
        
        let arquivar = UIAlertAction(title: "Arquivar relato", style: .default, handler: { (action) -> Void in
            FBRef.db.collection("stories").document(id).updateData(["status" : "archived"])
        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
            self.dismiss()
        }
        
        let alert = UIAlertController(title: "Deseja mesmo arquivar esse relato?", message: "Seus relatos arquivados só aparecem no seu perfil e não aparecerão mais para outras pessoas.", preferredStyle: .alert)
        alert.addAction(arquivar)
        alert.addAction(cancelar)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.buttonPink
    }
    
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        self.storyTextView.text = self.selectedStory?.data()["conteudo"] as! String
        
        if self.selectedStory?.data()["autor"] as? String == UserManager.instance.currentUser?.uid {
            chatButton.isEnabled = false
            
        }
        storyTextView.isEditable = false
    }
    

    
}
