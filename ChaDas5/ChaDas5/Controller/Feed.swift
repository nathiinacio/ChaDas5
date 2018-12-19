//
//  Feed.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase


class Feed: UIViewController, UITableViewDataSource, UITableViewDelegate, Manager {

    //outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        
        //table view setting
        self.feedTableView.separatorStyle = .none
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
        let nib = UINib.init(nibName: "FeedTableViewCell", bundle: nil)
        self.feedTableView.register(nib, forCellReuseIdentifier: "FeedCell")
    
        RelatoManager.instance.loadStories(requester: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return RelatoManager.instance.stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
//        
//        let doc  = RelatoManager.instance.stories[indexPath.row]
//        feedCell.feedTableViewTextField.text = doc.value(forKeyPath: "conteudo") as? String
        return feedCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    
    func readedStories(stories: [QueryDocumentSnapshot]) {
        print("got stories")
        feedTableView.reloadData()
    }
    
}
