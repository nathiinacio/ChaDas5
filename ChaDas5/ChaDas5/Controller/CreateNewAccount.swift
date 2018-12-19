//
//  CreateNewAccount.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class CreateNewAccount: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var pickYourTeaCollectionView: UICollectionView!
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        
        //collection view settings
        pickYourTeaCollectionView.allowsMultipleSelection = false
        pickYourTeaCollectionView.dataSource = self
        pickYourTeaCollectionView.delegate = self
        pickYourTeaCollectionView.allowsSelection = true
        pickYourTeaCollectionView.bounds.inset(by: pickYourTeaCollectionView.layoutMargins).width
        let nib = UINib.init(nibName: "ChooseYourTeaCollectionViewCell", bundle: nil)
        self.pickYourTeaCollectionView.register(nib, forCellWithReuseIdentifier: "PickYouTea")
    }
    
    //collection view settings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DAO.instance.teas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pickYouTeaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickYouTea", for: indexPath) as! ChooseYourTeaCollectionViewCell
        pickYouTeaCell.chooseYourTeaLabel.text = DAO.instance.teas[indexPath.item]
        return pickYouTeaCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        pickYourTeaCollectionView.allowsSelection = true
//        pickYourTeaCollectionView.allowsMultipleSelection = false
//        pickYourTeaCollectionView.beginInteractiveMovementForItem(at: indexPath)
//        pickYourTeaCollectionView.cellForItem(at: indexPath)?.isHighlighted = true
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ChooseYourTeaCollectionViewCell
        selectedCell.contentView.backgroundColor = UIColor.basePink
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
