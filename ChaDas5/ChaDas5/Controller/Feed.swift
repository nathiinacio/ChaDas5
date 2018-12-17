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
    
    var fetchingMore:Bool = false
    var stories:[DocumentReference] = []
    var lastDocumentSnapshot: DocumentSnapshot!
  
    
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
//        loadStories()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
//        if !self.stories.isEmpty {
//            for element in self.stories {
//                feedCell.textLabel?.text = (element.value(forKeyPath: "conteudo") as! String)
//            }
//        }
        return feedCell
    }
    
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        print("touched")
////        let offsetY = feedTableView.contentOffset.y
////        let contentHeight = feedTableView.contentSize.height
////        if offsetY > contentHeight - feedTableView.frame.height - 50 {
////            // Bottom of the screen is reached
////            print("bottom reached")
////            if !fetchingMore {
////                paginateData()
////            }
////        }
//    }

        // Paginates data
        func paginateData() {
            
            
        }
//
//    func loadStories() {
//        let docRef = FBRef.db.collection("Feed")
//        docRef.getDocuments { (querySnapshot, err) in
//        if let err = err {
//            print("Document error")
//        } else {
//            for document in querySnapshot!.documents {
//            self.stories.append(docRef.document(document.documentID))
//            }
//            }
//        }
//    }
    
   
    
}
