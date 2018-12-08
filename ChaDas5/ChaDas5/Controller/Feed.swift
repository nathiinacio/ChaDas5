//
//  Feed.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class Feed: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    //outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var feedTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let feedCell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedTableViewCell
    }
    
}
