//
//  StoryScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase

class StoryScreen: UIViewController {
    
    var selectedStory:QueryDocumentSnapshot?
    
    //outlets   
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    @IBOutlet weak var storyTextView: UITextView!
    
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        self.storyTextView.text = self.selectedStory?.data()["conteudo"] as! String
    }
    
}
