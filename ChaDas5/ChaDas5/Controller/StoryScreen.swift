//
//  StoryScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase


protocol ChannelCreationObserver {
    func created(channel: Channel)
}


class StoryScreen: UIViewController, ChannelsManagerProtocol, ChannelCreationObserver {
    
    func readedChannels(channels: [QueryDocumentSnapshot]) {
        print("not here too")
    }
    
    var selectedStory:QueryDocumentSnapshot?

    

    
    //outlets
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var storyTextView: UITextView!
    
    @IBAction func chatButton(_ sender: Any) {
    
  
        ChannelsManager.instance.createChannel(story: selectedStory!, requester: self)
    
        
        guard let id = ChannelsManager.instance.newChannelID else {
            return
        }
    
        
        let docRef = FBRef.db.collection("channels").document(id)
        
        guard let _ = Channel(document: docRef, channelRequester: self) else {
            print("deu ruim na criação do canal, se fode aí.")
            return
        }
        
        

    }
    
    func created(channel: Channel) {
        let vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel)
        
        present(vc, animated: true, completion: nil)
    }
    

    
    
    @IBAction func archiveButton(_ sender: Any) {
        
        guard let id = selectedStory?.documentID else {
            return
        }
        
        
        var property: String?
    
        let docRef = FBRef.db.collection("stories").document(id)
        
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                
                property = document.get("status") as? String
                
                print (property!)
                
                if property == "archived"
                {
                    let alert = UIAlertController(title: "Deseja mesmo desarquivar esse relato?", message: "Esse relato voltará a aparecer para outras pessoa no Feed.", preferredStyle: .alert)
                    
                    
                    
                    let desarquivar = UIAlertAction(title: "Desarquivar relato", style: .default, handler: { (action) -> Void in
                        FBRef.db.collection("stories").document(id).updateData(["status" : "active"])
                        self.dismiss()
                    })
                    
                    let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(desarquivar)
                    alert.addAction(cancelar)
                    self.present(alert, animated: true, completion: nil)
                    alert.view.tintColor = UIColor.buttonPink
                    
                    
                    
                }
                else{
                    
                    let alert = UIAlertController(title: "Deseja mesmo arquivar esse relato?", message: "Seus relatos arquivados só aparecem no seu perfil e não aparecerão mais para outras pessoas.", preferredStyle: .alert)
                    
                    
                    
                    let arquivar = UIAlertAction(title: "Arquivar relato", style: .default, handler: { (action) -> Void in
                        FBRef.db.collection("stories").document(id).updateData(["status" : "archived"])
                        self.dismiss()
                    })
                    
                    let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(arquivar)
                    alert.addAction(cancelar)
                    self.present(alert, animated: true, completion: nil)
                    alert.view.tintColor = UIColor.buttonPink
                    
                }
                
            } else {
                print("Document does not exist in cache")
            }
        }
        
        
        
        
    }
    
    
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        self.storyTextView.text = self.selectedStory?.data()["conteudo"] as! String
        
        if self.selectedStory?.data()["autor"] as? String == UserManager.instance.currentUser {
            chatButton.isEnabled = false
            
        } else {
            archiveButton.isEnabled = false
        }
        storyTextView.isEditable = false
    }
    

    
}
