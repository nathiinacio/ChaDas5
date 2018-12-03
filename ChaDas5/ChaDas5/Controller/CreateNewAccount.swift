//
//  CreateNewAccount.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class CreateNewAccount: UIViewController {
    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var pickYourTeaCollectionView: UICollectionView!
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
    }
    
}
