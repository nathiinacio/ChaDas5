//
//  ProfileTableViewCell.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 11/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let shared = ProfileTableViewCell()
    
    //outlets
    @IBOutlet weak var profileCellTextField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //actions
    @IBAction func deleteButton(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileCellTextField.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
