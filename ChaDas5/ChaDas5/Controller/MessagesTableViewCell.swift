//
//  MessagesTableViewCell.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 11/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewCell: UITableViewCell {
    
    
    //outlets
    @IBOutlet weak var messageTableViewImage: UIImageView!
    @IBOutlet weak var messageTableViewLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    
    
       var selectedStory:QueryDocumentSnapshot?
    
    
    //actions
    @IBAction func deleteButton(_ sender: Any) {
        
    
        
        guard let selected = myIndexPath?.row else {
            return
        }
        
         let channel = ChannelsManager.instance.channels[selected]
        
        print(channel)
        
//        guard let choosedChannel = Channel(document: channel) else {
//            print("Error retrieving channel")
//            return
//        }
        
//
//        print(choosedChannel.id!)
//
//        let selectedChannel = choosedChannel.id
        
        
        let alert = UIAlertController(title: "Deseja mesmo excluir essa conversa?", message: "A conversa será excluída para todos e essa ação não poderá ser desfeita.", preferredStyle: .alert)
        
        
        let excluir = UIAlertAction(title: "Excluir conversa", style: .default, handler: { (action) -> Void in
            FBRef.db.collection("channels").document(channel.id!)
                .delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.myMessageView?.messagesTableView.reloadData()
                }
            }
        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(excluir)
        alert.addAction(cancelar)
        myMessageView!.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.buttonPink

        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var myIndexPath:IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
    
    var myMessageView:Messages? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView")
            return nil
        }
        guard let messageView = superView.superview?.parentViewController as? Messages else {
            print("not a message descendant")
            return nil
            
        }
        
        return messageView
    }
    
}


