//
//  Informations.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class Informations: UIViewController {
    
    //main pages outlets
    @IBOutlet weak var whatToDoButton: UIButton!
    @IBOutlet weak var numbersButton: UIButton!
    @IBOutlet weak var informationsButton: UIButton!
    
    //what to do
    @IBAction func whatToDoDismissButton(_ sender: Any) {
        self.dismiss()
    }
    
    @IBAction func numbersDismissButton(_ sender: Any) {
        self.dismiss()
    }
    @IBAction func informationDismissButton(_ sender: Any) {
        self.dismiss()
    }
    
    
    //dismiss func
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
