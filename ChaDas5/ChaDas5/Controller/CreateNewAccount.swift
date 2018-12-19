//
//  CreateNewAccount.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class CreateNewAccount: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selected:ChooseYourTeaCollectionViewCell?
    
    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var pickYourTeaCollectionView: UICollectionView!    
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    //var yourTea: String!
    var activityView:UIActivityIndicatorView!
    //actions
    @IBAction func createNewButton(_ sender: Any) {
    }
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
        
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordConfirmationTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
        //        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmationTextField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        createNewAccountButton.center = CGPoint(x: view.center.x,
                                                y: view.frame.height - keyboardFrame.height - 16.0 - createNewAccountButton.frame.height / 2)
        activityView.center = createNewAccountButton.center
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
        self.selected = selectedCell
        print("foi")
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? ChooseYourTeaCollectionViewCell
        selectedCell?.contentView.backgroundColor = UIColor.white
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailTextField.text
        let passwordConfirmed = passwordConfirmationTextField.text
        let password = passwordTextField.text
        let formFilled = email != nil && email != "" && passwordConfirmed != nil && passwordConfirmed != "" && password != nil && password != ""
        setcreateNewAccountButton(enabled: formFilled)
    }
    
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        // Resigns the target textField and assigns the next textField in the form.
//
//        switch textField {
//        case emailTextField:
//            emailTextField.resignFirstResponder()
//            passwordTextField.becomeFirstResponder()
//            break
//        case passwordTextField:
//            passwordTextField.resignFirstResponder()
//            passwordConfirmationTextField.becomeFirstResponder()
//            break
//        case passwordConfirmationTextField:
//            handleSignUp()
//            break
//        default:
//            break
//        }
//        return true
//    }
    
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        guard let yourTea = self.selected!.chooseYourTeaLabel.text else { return }
        
        setcreateNewAccountButton(enabled: false)
        createNewAccountButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = email
               
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
                        
                        self.saveProfile(username: yourTea) { success in
                            if success {
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.resetForm()
                        }
                    }
       
                }
            }
        }
    }

    
}
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error signing up", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setcreateNewAccountButton(enabled: true)
        createNewAccountButton.setTitle("Continue", for: .normal)
        activityView.stopAnimating()
    }
    
    
    func saveProfile(username:String, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": username,
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    
    /**
     Enables or Disables the **continueButton**.
     */
    
    func setcreateNewAccountButton(enabled:Bool) {
        if enabled {
            createNewAccountButton.alpha = 1.0
            createNewAccountButton.isEnabled = true
        } else {
            createNewAccountButton.alpha = 0.5
            createNewAccountButton.isEnabled = false
        }
    }
    
    
    
    
}

