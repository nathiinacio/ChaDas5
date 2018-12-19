//
//  NewStoryScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class NewStoryScreen: UIViewController {
    
    //outlets
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func sendButton(_ sender: Any) {
    }
    @IBOutlet weak var newStoryTextView: UITextView!
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
    }
    
    
    
}
