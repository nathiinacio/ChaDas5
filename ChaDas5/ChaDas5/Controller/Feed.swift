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
    

    
    var xibCell:FeedTableViewCell?

    var selectedIndex:Int?

    //outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var noStoryLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        //table view setting
        self.feedTableView.separatorStyle = .none
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.allowsSelection = true
        let nib = UINib.init(nibName: "FeedTableViewCell", bundle: nil)
        self.feedTableView.register(nib, forCellReuseIdentifier: "FeedCell")
    
        RelatoManager.instance.loadStories(requester: self)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return RelatoManager.instance.stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
        
        if !RelatoManager.instance.stories.isEmpty {
            let doc = RelatoManager.instance.stories[indexPath.row]
            
            feedCell.feedTableViewTextField.text = doc.data()["conteudo"] as! String
            
            feedCell.selectionStyle = .none
        }

        return feedCell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell
        selectedCell.contentView.backgroundColor = UIColor.clear
        self.selectedIndex = indexPath.row
        
        self.performSegue(withIdentifier: "storyScreen", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell
        selectedCell?.contentView.backgroundColor = UIColor.white
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storyScreen" {
            print("go to Story")
            if let destinationVC = segue.destination as? StoryScreen{
                destinationVC.selectedStory = RelatoManager.instance.stories[self.selectedIndex!]
            }
        }
    }
    
    func readedStories(stories: [QueryDocumentSnapshot]) {
        print("got stories")
        feedTableView.reloadData()
    }
    
    func readedMyStories(stories: [QueryDocumentSnapshot]) {
        print("not here")
    }
    
    
}

