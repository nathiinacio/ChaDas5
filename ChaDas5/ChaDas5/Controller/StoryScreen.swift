//
//  StoryScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class StoryScreen: UIViewController {
    
    //outlets   
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    @IBOutlet weak var storyTextView: UITextView!
    
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
