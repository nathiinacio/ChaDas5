//
//  Profile.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit





//struct MyStory {
//    var postDate:Date
//    var title:String
//    var description:String
//}
//
//var myStories:[MyStory] = []
//
//  var datasources = [myStories]



class Profile: UIViewController {
    
    
    var segmentedControl: CustomSegmentedContrl!

    @IBOutlet weak var profileLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        segmentedControl = CustomSegmentedContrl.init(frame: CGRect.init(x: 0, y: 300, width: self.view.frame.width, height: 45))
        segmentedControl.backgroundColor = .white
        segmentedControl.commaSeperatedButtonTitles = "Relatos passados, Relatos atuais"
        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
        
        self.view.addSubview(segmentedControl)
        
    }
    
    
    
    
    @objc func onChangeOfSegment(_ sender: CustomSegmentedContrl) {
        
        
        profileLabel.text = "meu segmento é: \(sender.selectedSegmentIndex)"
    }
    
//    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
//
//    @IBAction func segmentedTapped(_ sender: Any) {
//
//        let getIndex = profileSegmentedControl.selectedSegmentIndex
//
//        switch (getIndex) {
//        case 0:
//            self.profileLabel.backgroundColor = UIColor.red
//        case 1:
//            self.profileLabel.backgroundColor = UIColor.blue
//        default:
//            self.profileLabel.backgroundColor = UIColor.red
//        }
    
}
    

    

