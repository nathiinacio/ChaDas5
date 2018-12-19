//
//  SplashScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 19/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {
    
    //outlets
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var splashImage: UIImageView!
    
    override func viewDidLoad() {
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 1, animations: {
        
        self.splashView.frame.origin.y -= 307
        
        
        }, completion: nil)
    }
    
    
}
