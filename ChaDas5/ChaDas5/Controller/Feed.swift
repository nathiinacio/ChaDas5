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

        Auth.auth().signInAnonymously(completion: nil)
        print("logged")
        print(FBRef.db.collection("Feed").collectionID)
        loadStories()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
        return feedCell
    }
    

    func paginateData() {
    }

    func loadStories() {
        let docRef = FBRef.db.collection("Feed")
        docRef.getDocuments { (querySnapshot, err) in
        print("************ To Aqui ************")
        if let err = err {
            print("Document error")
        } else {
            for document in querySnapshot!.documents {
                print(document.documentID)
                
            }
            }
        }
    }
    
   
    
}
