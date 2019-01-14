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
    
  
    var index: IndexPath?
    
    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var pickYourTeaCollectionView: UICollectionView!    
    @IBOutlet weak var createNewAccountButton: UIButton!

    
    private let db = Firestore.firestore()
    
    var activityView:UIActivityIndicatorView!
    
    //actions
    @IBAction func createNewButton(_ sender: Any) {
        
        if passwordTextField.text == passwordConfirmationTextField.text && selected?.chooseYourTeaLabel.text != nil
        {
            handleSignUp()
            
        }
        else{
            
            if passwordTextField.text != passwordConfirmationTextField.text {
                
            let tentarNovamente = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { (action) -> Void in
                self.passwordConfirmationTextField.text = ""
                self.passwordTextField.text = ""
            })
            let alert = UIAlertController(title: "Oops...", message: "Erro na confirmação de senha", preferredStyle: .alert)
            alert.addAction(tentarNovamente)
            self.present(alert, animated: true, completion: nil)
            alert.view.tintColor = UIColor.buttonPink
                
            }
            
            else {
                let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                })
                let alert = UIAlertController(title: "Oops...", message: "Esqueceu de escolher seu chá", preferredStyle: .alert)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                alert.view.tintColor = UIColor.buttonPink
                
            }
        }
        
        
        
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        
        passwordTextField.isSecureTextEntry = true
        passwordConfirmationTextField.isSecureTextEntry = true
        
        //collection view settings
        pickYourTeaCollectionView.allowsMultipleSelection = false
        pickYourTeaCollectionView.dataSource = self
        pickYourTeaCollectionView.delegate = self
        pickYourTeaCollectionView.allowsSelection = true
        pickYourTeaCollectionView.bounds.inset(by: pickYourTeaCollectionView.layoutMargins).width
        let nib = UINib.init(nibName: "ChooseYourTeaCollectionViewCell", bundle: nil)
        self.pickYourTeaCollectionView.register(nib, forCellWithReuseIdentifier: "PickYouTea")
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = UIColor.buttonPink
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = createNewAccountButton.center
        
        view.addSubview(activityView)
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordConfirmationTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    
        setcreateNewAccountButton(enabled: false)
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
        
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
        //        pickYourTeaCollectionView.allowsSelection = true
        //        pickYourTeaCollectionView.allowsMultipleSelection = false
        //        pickYourTeaCollectionView.beginInteractiveMovementForItem(at: indexPath)
        //        pickYourTeaCollectionView.cellForItem(at: indexPath)?.isHighlighted = true
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ChooseYourTeaCollectionViewCell
        selectedCell.contentView.backgroundColor = UIColor.basePink
        self.selected = selectedCell
        self.index = collectionView.indexPath(for: selected!)
    
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
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            passwordConfirmationTextField.becomeFirstResponder()
            break
        case passwordConfirmationTextField:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        guard let yourTea = self.selected!.chooseYourTeaLabel.text else { return }
        

        setcreateNewAccountButton(enabled: false)
        createNewAccountButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        
        
        Auth.auth().fetchProviders(forEmail: email, completion: { (stringArray, error) in
            if error != nil {
                print(error!)
            } else {
                if stringArray == nil {
                    print("No password. No active account")
                
                    Auth.auth().createUser(withEmail: email, password: pass) { user, error in
                        if error == nil && user != nil {
                            print("User created!")
                            
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = yourTea
                            
                            changeRequest?.commitChanges { error in
                                if error == nil {
                                    print("User display name changed!")
                                    
                                    Auth.auth().currentUser?.sendEmailVerification(completion:
                                        {(error) in
                                            if error == nil
                                            {
                                                let ok = UIAlertAction(title: "Ok, verifiquei!", style: .default, handler: { (action) -> Void in
                                                   
                                                    Auth.auth().currentUser?.reload(completion: { (err) in
                                                        if err == nil{
                                                            
                                                            
                                                            if Auth.auth().currentUser!.isEmailVerified {
                                                                print("VERIFIED")
                                                                
                                                                self.saveProfile(username: yourTea) { success in
                                                                    if success {
                                                                        self.dismiss(animated: true, completion: nil)
                                                                    } else {
                                                                        self.resetForm()
                                                                        Auth.auth().currentUser?.delete(completion: nil)
                                                                    }
                                                                }
                                                                
                                                            } else {
                                                                
                                                                print("It aint verified yet")
                                                                
                                                                let alertVC = UIAlertController(title: "Erro", message: "Desculpe. Seu e-mail ainda não foi verificado, deseja reenviar o e-mail de verificação para \(email)?", preferredStyle: .alert)
                                                                
                                                                let alertActionOkay = UIAlertAction(title: "Reenviar", style: .default) {
                                                                    (_) in
                                                                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                                                                }
                                                             
                                                                let alertActionVerified = UIAlertAction(title: "Ok, verifiquei!", style: .default, handler: { (action) -> Void in
                                                                    
                                                                    Auth.auth().currentUser?.reload()
                                                                    if (!(Auth.auth().currentUser?.isEmailVerified)!) {
                                                                     
                                                                    } else {
                                                                        self.saveProfile(username: yourTea) { success in
                                                                            if success {
                                                                                self.dismiss(animated: true, completion: nil)
                                                                            } else {
                                                                                self.resetForm()
                                                                            
                                                                            }
                                                                        }
                                                                                                                                            }
                                                                })
                                                                
                                                                let alertActionCancel = UIAlertAction(title: "Cancelar", style: .default) {
                                                                    (_) in
                                                                    Auth.auth().currentUser?.delete(completion: nil)
                                                                   self.dismiss()
                                                                }
                                                                
                                                                
                                                                alertVC.addAction(alertActionOkay)
                                                                alertVC.addAction(alertActionVerified)
                                                                alertVC.addAction(alertActionCancel)
                                                                
                                                                alertVC.view.tintColor = UIColor.buttonPink
                                                                self.present(alertVC, animated: true, completion: nil)
                                                                
                                                            }
                                                        } else {
                                                            
                                                            print(err?.localizedDescription)
                                                            
                                                        }
                                                    })
                                                
                                                    
                                                })
                                                let alert = UIAlertController(title: "E-mail de verificação", message: "Um e-mail de verificação foi enviado, por favor cheque seu e-mail", preferredStyle: .alert)
                                                alert.addAction(ok)
                                                self.present(alert, animated: true, completion: nil)
                                                alert.view.tintColor = UIColor.buttonPink
                                                
                                            }
                                            else{
                                                
                                            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                                                })
                                            let alert = UIAlertController(title: "Erro", message: "Erro no envio do e-mail de verificação", preferredStyle: .alert)
                                            alert.addAction(ok)
                                            self.present(alert, animated: true, completion: nil)
                                            alert.view.tintColor = UIColor.buttonPink
                                    }
                                    })

                                    
                                    
                                } else {
                                    print("Error: \(error!.localizedDescription)")
                                    self.resetForm()
                                    Auth.auth().currentUser?.delete(completion: nil)
                                }
                            }
                            
                        } else {
                            self.resetForm()
                            Auth.auth().currentUser?.delete(completion: nil)
                        }
                    }
                    
                } else {
                    print("There is an active account")
                    let tentarNovamente = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { (action) -> Void in
                        self.emailTextField.text = ""
                        self.passwordConfirmationTextField.text = ""
                        self.passwordTextField.text = ""
                        Auth.auth().currentUser?.delete(completion: nil)
                        self.pickYourTeaCollectionView.deselectItem(at: self.index!, animated: true)
                        
                    })
        
                    let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
                        self.dismiss()
                        Auth.auth().currentUser?.delete(completion: nil)
                        
                    }
        
                    let alert = UIAlertController(title: "Oops...", message: "E-mail já usado anteriormente", preferredStyle: .alert)
                    alert.addAction(tentarNovamente)
                    alert.addAction(cancelar)
                    self.present(alert, animated: true, completion: nil)
                    alert.view.tintColor = UIColor.buttonPink
        
                    self.setcreateNewAccountButton(enabled: true)
                    self.createNewAccountButton.setTitle("Criar Conta", for: .normal)
                    self.activityView.stopAnimating()
                }
            }
        })
        
        
    }
    

    func saveProfile(username:String, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document("\(uid)").setData([
            "username": username
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.db.collection("users").document("\(uid)").collection("myChannels").document("first").setData(["channelID" : ""])
                self.performSegue(withIdentifier: "Feed", sender: self)
            }
        }
        
    }
    
    func resetForm() {
       
        let tentarNovamente = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { (action) -> Void in
            self.emailTextField.text = ""
            self.passwordConfirmationTextField.text = ""
            self.passwordTextField.text = ""
            self.pickYourTeaCollectionView.deselectItem(at: self.index!, animated: true)
            
        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
            self.dismiss()
        }
        
        let alert = UIAlertController(title: "Oops...", message: "Ocorreu algum erro com seus dados", preferredStyle: .alert)
        alert.addAction(tentarNovamente)
        alert.addAction(cancelar)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.buttonPink
        
        setcreateNewAccountButton(enabled: true)
        createNewAccountButton.setTitle("Criar Conta", for: .normal)
        activityView.stopAnimating()
    }
    
    

    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
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

extension UICollectionView {
    
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}







