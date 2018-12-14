//
//  Messages.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class Messages: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //outlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        
        //table view setting
        self.messagesTableView.separatorStyle = .none
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        let nib = UINib.init(nibName: "MessagesTableViewCell", bundle: nil)
        self.messagesTableView.register(nib, forCellReuseIdentifier: "MessagesCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messagesCell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesTableViewCell
//        messagesCell.messageTableViewLabel.text = "ói eu aqui \(indexPath.row)"
         return messagesCell
    }
    
}
