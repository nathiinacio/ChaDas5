//
//  ViewExtensions.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 01/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

extension UIColor {
    static let basePink = UIColor(red:247.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    static let buttonPink = UIColor(red:255.0/255.0, green: 157.0/255.0, blue: 130.0/255.0, alpha: 1.0)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
