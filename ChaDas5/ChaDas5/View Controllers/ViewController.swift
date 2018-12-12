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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Auth.auth().signInAnonymously(completion: nil)
        print("*******************logado*******************")
      
    }

}

