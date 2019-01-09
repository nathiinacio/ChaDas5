//
//  Messages.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase

class Messages: UIViewController, UITableViewDataSource, UITableViewDelegate, ChannelsManagerProtocol {
    
    
    
    //outlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var noStoryLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        //table view setting
        self.messagesTableView.separatorStyle = .none
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.allowsSelection = true
        let nib = UINib.init(nibName: "MessagesTableViewCell", bundle: nil)
        self.messagesTableView.register(nib, forCellReuseIdentifier: "MessagesCell")
        ChannelsManager.instance.loadChannels(requester: self)
    }
    
    func addToMyChannels() {
        print("not here")
    }
    
    func readedChannels(channels: [QueryDocumentSnapshot]) {
        messagesTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //falta o outlet
        return ChannelsManager.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messagesCell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesTableViewCell

        messagesCell.messageTableViewLabel.text = "channel"
        return messagesCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! MessagesTableViewCell
        selectedCell.contentView.backgroundColor = UIColor.basePink
        
        let channel = ChannelsManager.instance.channels[indexPath.row]
        let user = UserManager.instance.currentUser!
        guard let choosedChannel = Channel(document: channel) else {
            print("Bota o alerta do se fudeu")
            return
        }
        let vc = ChatViewController(user: user, channel: choosedChannel)
//        guard let nc = navigationController  else {
//            print("Bota o alerta do se fudeu")
//            return
//        }
        present(vc, animated: true, completion: nil)
//        nc.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as? MessagesTableViewCell
        selectedCell?.contentView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    
}
