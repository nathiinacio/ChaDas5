//
//  Messages.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase

class Messages: UIViewController, UITableViewDataSource, UITableViewDelegate, ChannelsManagerProtocol{
    
    //outlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var noStoryLabel: UILabel!
    
    var messageIsEditing =  false
    var activityView:UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    //actions    
    @IBAction func editButton(_ sender: Any) {
        
        if !messageIsEditing {
            messageIsEditing = true
        } else {
            messageIsEditing = false
        }
        messagesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        //table view setting
        self.messagesTableView.separatorStyle = .none
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.allowsSelection = true
        let nib = UINib.init(nibName: "MessagesTableViewCell", bundle: nil)
        self.messagesTableView.register(nib, forCellReuseIdentifier: "MessagesCell")
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = UIColor.buttonPink
        activityView.frame = CGRect(x: 0, y: 0, width: 300.0, height: 300.0)
        activityView.center = view.center
        activityView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        noStoryLabel.alpha = 0
        
        view.addSubview(activityView)
        
        activityView.startAnimating()
        
        messagesTableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.buttonPink
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        messageIsEditing =  false
        
        ChannelsManager.instance.preLoad(requester: self)
        
        
    }
    
    func readedChannels(channels: [Channel]) {
        messagesTableView.reloadData()
        activityView.stopAnimating()
        if ChannelsManager.instance.channels.count == 0 {
            self.noStoryLabel.alpha = 1
            self.noStoryLabel.text = "Você não possui conversas ainda..."
        } else {
            self.noStoryLabel.alpha = 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChannelsManager.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messagesCell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesTableViewCell
        messagesCell.deleteButton.alpha = messageIsEditing ? 1 : 0
        
        if ChannelsManager.instance.channels.isEmpty {
            return messagesCell
        } else {
            let channel = ChannelsManager.instance.channels[indexPath.row]
            
            var username: String?
            if UserManager.instance.currentUser == channel.firstUser?.uid {
                if let displayName = channel.secondUser?.displayName {
                    username = displayName
                }
            } else {
                if let displayName = channel.firstUser?.displayName {
                    username = displayName
                }
            }
            if (username != nil) {
                let photo = UIImage.init(named: username!)
                messagesCell.messageTableViewLabel.text = username
                messagesCell.messageTableViewImage.image = photo
            }
        }
        return messagesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! MessagesTableViewCell
        selectedCell.contentView.backgroundColor = UIColor.clear
        let channel = ChannelsManager.instance.channels[indexPath.row]
        let vc = ChatViewController(channel: channel)
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    @objc private func refreshData(_ sender: Any) {
        ChannelsManager.instance.preLoad(requester: self)
        self.refreshControl.endRefreshing()
        
    }
    
}
