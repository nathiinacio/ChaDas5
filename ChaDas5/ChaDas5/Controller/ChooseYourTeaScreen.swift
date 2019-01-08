//
//  ChooseYourTeaScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 08/01/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import  UIKit
import Foundation
import Firebase

class ChooseYourTeaScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var chooseYourTeaCollectionView: UICollectionView!
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    
    var selected:ChooseYourTeaCollectionViewCell?
    var index: IndexPath?
    
    var pickYourTeaCell: ChooseYourTeaCollectionViewCell?
    
    override func viewDidLoad() {
        //collection view settings
        chooseYourTeaCollectionView.allowsMultipleSelection = false
        chooseYourTeaCollectionView.dataSource = self
        chooseYourTeaCollectionView.delegate = self
        chooseYourTeaCollectionView.allowsSelection = true
        chooseYourTeaCollectionView.bounds.inset(by: chooseYourTeaCollectionView.layoutMargins).width
        let nib = UINib.init(nibName: "ChooseYourTeaCollectionViewCell", bundle: nil)
        self.chooseYourTeaCollectionView.register(nib, forCellWithReuseIdentifier: "ChooseYourTea")
    }
    
    //collection view settings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DAO.instance.teas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pickYouTeaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickYouTea", for: indexPath) as! ChooseYourTeaCollectionViewCell
        pickYouTeaCell.chooseYourTeaLabel.text = DAO.instance.teas[indexPath.item]
        pickYouTeaCell.chooseYourteaImage.image = UIImage(named:  DAO.instance.teas[indexPath.item])
        pickYouTeaCell.chooseYourteaImage.contentMode = UIView.ContentMode.scaleAspectFit
        return pickYouTeaCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ChooseYourTeaCollectionViewCell
        selectedCell.contentView.backgroundColor = UIColor.basePink
        self.selected = selectedCell
        self.index = collectionView.indexPath(for: selected!)
        print("foi")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? ChooseYourTeaCollectionViewCell
        selectedCell?.contentView.backgroundColor = UIColor.white
    }
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
