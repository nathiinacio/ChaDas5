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
    
    var activityView:UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
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
        activityView.center = messagesTableView.center
        activityView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        noStoryLabel.alpha = 0
        
        view.addSubview(activityView)
        
        activityView.startAnimating()
        
        messagesTableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.buttonPink
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        
        ChannelsManager.instance.loadChannels(requester: self)
        
        
    }
    
    func addToMyChannels() {
        print("not here")
    }
    
    func readedChannels(channels: [QueryDocumentSnapshot]) {
        messagesTableView.reloadData()
        activityView.stopAnimating()
        if ChannelsManager.instance.channels.count == 0 {
            self.noStoryLabel.alpha = 1
            self.noStoryLabel.text = "Você não possui conversas ainda..."
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return ChannelsManager.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messagesCell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesTableViewCell

        messagesCell.messageTableViewLabel.text = "channel"
        return messagesCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! MessagesTableViewCell
        selectedCell.contentView.backgroundColor = UIColor.clear
        
        let channel = ChannelsManager.instance.channels[indexPath.row]
        let user = UserManager.instance.currentUser!
        print(channel)
        guard let choosedChannel = Channel(document: channel) else {
            print("Error retrieving channel")
            return
        }
        let vc = ChatViewController(user: user, channel: choosedChannel)
        present(vc, animated: true, completion: nil)
        
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let selectedCell = tableView.cellForRow(at: indexPath) as? MessagesTableViewCell
//        selectedCell?.contentView.backgroundColor = UIColor.white
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        ChannelsManager.instance.loadChannels(requester: self)
        self.refreshControl.endRefreshing()
        
    }
    
    
    
}
