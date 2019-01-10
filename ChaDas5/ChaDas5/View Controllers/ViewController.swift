//
//  ViewController.swift
//  ChaDas5
//
//  Created by Julia Maria Santos on 26/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
    
      
        super.viewDidLoad()
        
//        print("USER 2:")
//        print(UserManager.instance.currentUser?.uid)
//
        // Do any additional setup after loading the view, typically from a nib.
        
//        Auth.auth().signInAnonymously(completion: nil)
//        print("*******************logado*******************")
//      
//        Relato(conteudo: "teste time stamp", autor: "testador do time stamp")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        createNewAccountButtonAnimation()
        loginButtonAnimation ()
    }
    
    //create new account button animation
    func createNewAccountButtonAnimation () {
        createNewAccountButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.createNewAccountButton.transform = .identity
        })
    }
    
    // login button animation
    func loginButtonAnimation () {
        loginButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.loginButton.transform = .identity
        })
    }

}

