//
//  NewStoryScreen.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit

class NewStoryScreen: UIViewController, UITextViewDelegate {
    
    //outlets
    
    @IBOutlet weak var newStoryLabel: UILabel!    
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    
    //actions
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }
    @IBAction func sendButton(_ sender: Any) {
        
        Relato(conteudo: newStoryTextView.text, autor: (UserManager.instance.currentUser?.uid)!).fbSave()
        
        dismiss()
    }
    @IBOutlet weak var newStoryTextView: UITextView!
    
    override func viewDidLoad() {
        
        hideKeyboardWhenTappedAround()
        
        //código novo
        
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        
        mytapGestureRecognizer.numberOfTapsRequired = 1
        
        self.newStoryTextView.addGestureRecognizer(mytapGestureRecognizer)
        

        
    }
    
    
    @objc func myTapAction(recognizer: UITapGestureRecognizer) {
        
        print("TAPPED")
        newStoryLabel.text = ""
        
    
    }
    
    // acaba aqui
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
