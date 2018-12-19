//
//  Feed.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase


class Feed: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var stories = [QueryDocumentSnapshot]()
    var lastDocumentSnapshot: DocumentSnapshot!
    var fetchingMore = false
  
    
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
        loadStories()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.stories.isEmpty {
            return self.stories.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
        
//        if !self.stories.isEmpty {
//            for doc in self.stories {
//                feedCell.textLabel?.text = doc.get("conteudo")! as? String
//            }
//        }
        return feedCell
    }
    
    func loadStories() {
        let docRef = FBRef.db.collection("Feed")
        docRef.getDocuments { (querySnapshot, err) in
        if let err = err {
            print("Document error")
        } else {
            for document in querySnapshot!.documents {
                self.stories.append(document)
            }
            }
        }
        feedTableView.reloadData()
    }
    
    func createStoriesForTesting() {
        for i in 2...10 {
            let autor:String = "anonimo\(i)"
            let conteudo:String = "relato do anonimo \(i)"
            Relato(conteudo: conteudo, autor: autor).fbSave()
        }
        
    }
    
   
    
}
