//
//  MessagesTableViewCell.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 11/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    static let shared = MessagesTableViewCell()
    
    //outlets
    @IBOutlet weak var messageTableViewImage: UIImageView!
    @IBOutlet weak var messageTableViewLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    //actions
    @IBAction func deleteButton(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
