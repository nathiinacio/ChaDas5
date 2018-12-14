//
//  ChooseYourTeaCollectionViewCell.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 13/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class ChooseYourTeaCollectionViewCell: UICollectionViewCell {
    
    static let shared = ChooseYourTeaCollectionViewCell()
    
    //outlets
    @IBOutlet weak var chooseYourteaImage: UIImageView!
    @IBOutlet weak var chooseYourTeaLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
