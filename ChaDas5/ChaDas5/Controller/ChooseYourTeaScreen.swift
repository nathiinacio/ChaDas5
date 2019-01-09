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
    
    
   
    @IBOutlet weak var salvar: UIButton!
    
    @IBOutlet weak var chooseYourTeaCollectionView: UICollectionView!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    
    var selected:ChooseYourTeaCollectionViewCell?
    private let db = Firestore.firestore()
    
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
        self.chooseYourTeaCollectionView.register(nib, forCellWithReuseIdentifier: "PickYouTea")
        salvar.alpha = 0.5
        salvar.isEnabled = false
    }
    
    //collection view settings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.instance.teas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pickYouTeaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickYouTea", for: indexPath) as! ChooseYourTeaCollectionViewCell
        pickYouTeaCell.chooseYourTeaLabel.text = UserManager.instance.teas[indexPath.item]
        pickYouTeaCell.chooseYourteaImage.image = UIImage(named:  UserManager.instance.teas[indexPath.item])
        pickYouTeaCell.chooseYourteaImage.contentMode = UIView.ContentMode.scaleAspectFit
        return pickYouTeaCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ChooseYourTeaCollectionViewCell
        selectedCell.contentView.backgroundColor = UIColor.basePink
        self.selected = selectedCell
        salvar.alpha = 1
        salvar.isEnabled = true
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
    
    
    
    @IBAction func salvar(_ sender: Any) {
        
    
        guard let yourTea = self.selected!.chooseYourTeaLabel.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document("\(uid)").setData([
            "username": yourTea
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.db.collection("users").document("\(uid)").collection("myChannels").document("first").setData(["channelID" : ""])
                //self.performSegue(withIdentifier: "Feed", sender: self)
                Auth.auth().currentUser?.reload()
                self.dismiss()
            }
        }
        
        
    }
    
    
}
