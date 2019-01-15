//
//  ProfileTableViewCell.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 11/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewCell: UITableViewCell {
    
    //outlets
    @IBOutlet weak var profileCellTextField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedStory:QueryDocumentSnapshot?
   
    
    //actions
    @IBAction func deleteButton(_ sender: Any) {
        
        guard let selected = myIndexPath?.row else {
            return
        }
        
        if myProfileView?.currentSegment == 0 {
           
            self.selectedStory = MyStoriesManager.instance.relatosPassados[selected]
        
        }
        
        else{
            
            self.selectedStory = MyStoriesManager.instance.relatosAtuais[selected]

        }
        
        
        guard let id = selectedStory?.documentID else {
            return
        }
        
        let alert = UIAlertController(title: "Deseja mesmo excluir esse relato?", message: "", preferredStyle: .alert)
        
        
        
        let excluir = UIAlertAction(title: "Excluir relato", style: .default, handler: { (action) -> Void in
            FBRef.db.collection("stories").document(id).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.myProfileView?.profileTableView.reloadData()
                }
            }
        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(excluir)
        alert.addAction(cancelar)
        myProfileView!.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.buttonPink

    
}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileCellTextField.isEditable = false
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var myIndexPath:IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
    
    var myProfileView:Profile? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView")
            return nil
        }
        guard let profileView = superView.superview?.parentViewController as? Profile else {
            print("not a profile descendant")
            return nil

        }
        
        return profileView
    }
    
}




extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
