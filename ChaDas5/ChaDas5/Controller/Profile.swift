//
//  Profile.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase




//struct MyStory {
//    var postDate:Date
//    var title:String
//    var description:String
//}
//
//var myStories:[MyStory] = []
//
//  var datasources = [myStories]



class Profile: UIViewController, UITableViewDataSource, UITableViewDelegate, Manager {
    
   
    var segmentedControl: CustomSegmentedContrl!

    //outlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var noStoryLabel: UILabel!
    @IBOutlet weak var pickYouTeaButton: UIButton!
    @IBOutlet weak var imageCircle: UIButton!
    
    
    @IBAction func pickYourTeaButton(_ sender: Any) {
        performSegue(withIdentifier: "toChooseYourTea", sender: nil)
        imageCircle.alpha = 1
        profileImage.alpha = 1
        pickYouTeaButton.alpha = 0
    }
    
    //actions
    @IBAction func logoutButton(_ sender: Any) {

        
        try! Auth.auth().signOut()
        
    }
    

    @IBAction func editButton(_ sender: Any) {
        imageCircle.alpha = 0.25
        profileImage.alpha = 0.25
        pickYouTeaButton.alpha = 1
        
    }
    
    
    
    override func viewDidLoad() {
        
        //segmented control customization
        segmentedControl = CustomSegmentedContrl.init(frame: CGRect.init(x: 0, y: 300, width: self.view.frame.width, height: 45))
        segmentedControl.backgroundColor = .white
        segmentedControl.commaSeperatedButtonTitles = "Relatos passados, Relatos atuais"
        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
        self.view.addSubview(segmentedControl)
        
        //table view setting
        self.profileTableView.separatorStyle = .none
        profileTableView.dataSource = self
        profileTableView.delegate = self
        let nib = UINib.init(nibName: "ProfileTableViewCell", bundle: nil)
        self.profileTableView.register(nib, forCellReuseIdentifier: "ProfileCell")
        
        nameLabel.text = AppSettings.displayName
        profileImage.image = UIImage(named: AppSettings.displayName)
        profileImage.contentMode =  UIView.ContentMode.scaleAspectFit
        pickYouTeaButton.alpha = 0
        
        Auth.auth().currentUser?.reload()
        
    }
    
   
    var dadosDaTableView = DAO.instance.todosOsDados[0]

    //segmented control adjustments
    @objc func onChangeOfSegment(_ sender: CustomSegmentedContrl) {
        
        dadosDaTableView = DAO.instance.todosOsDados[sender.selectedSegmentIndex]
        profileTableView.reloadData()

        
    }
    
    //table view setting
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.instance.todosOsDados[segmentedControl.selectedSegmentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileTableViewCell
        profileCell.profileCellTextField.text = DAO.instance.todosOsDados[segmentedControl.selectedSegmentIndex][indexPath.row]

        return profileCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func readedStories(stories: [QueryDocumentSnapshot]) {
        print("not here")
    }
    
    func readedMyStories(stories: [QueryDocumentSnapshot]) {
        print("readed my stories")
        profileTableView.reloadData()
    }
    
    
}



    

