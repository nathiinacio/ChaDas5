//
//  Login.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class Login: UIViewController {
    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //action
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }    
    @IBAction func loginButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
    }
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
