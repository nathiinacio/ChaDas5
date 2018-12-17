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
    var stories = [Relato]()
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
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
        return feedCell
    }
    
    //PAGINACAO SCROLLVIEW
    
//    override func update(_ currentTime: TimeInterval) {
//        
//            let offsetY = feedTableView.contentOffset.y
//            let contentHeight = feedTableView.contentSize.height
//            //print("offsetY: \(offsetY) | contHeight-scrollViewHeight: \(contentHeight-scrollView.frame.height)")
//            if offsetY > contentHeight - feedTableView.frame.height - 50 {
//                // Bottom of the screen is reached
//                if !fetchingMore {
//                    paginateData()
//                }
//            }
//        }
//    
//        // Paginates data
//        func paginateData() {
//    
//            fetchingMore = true
//    
//            var query: Query!
//    
//            if stories.isEmpty {
//                query = FBRef.db.collection("Feed").order(by: "data").limit(to: 6)
//                print("First 6 stories loaded")
//            } else {
//                query = FBRef.db.collection("Feed").order(by: "data").start(afterDocument: lastDocumentSnapshot).limit(to: 4)
//                print("Next 4 stories loaded")
//            }
//    
//            query.getDocuments { (snapshot, err) in
//                if let err = err {
//                    print("\(err.localizedDescription)")
//                } else if snapshot!.isEmpty {
//                    self.fetchingMore = false
//                    return
//                } else {
//                    let newStories = snapshot!.documents.compactMap({_ in Relato.toDictionary(Data())})
//                    self.stories.append(contentsOf: newStories)
//    
//                    //
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                        self.feedTableView.reloadData()
//                        self.fetchingMore = false
//                    })
//    
//                    self.lastDocumentSnapshot = snapshot!.documents.last
//                }
//            }
//        }
    
   
    
}
