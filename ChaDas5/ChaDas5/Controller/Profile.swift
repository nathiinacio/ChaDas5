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


    func readedMyStories(stories: [[QueryDocumentSnapshot]]) {
        profileTableView.reloadData()
        self.activityView.stopAnimating()
        let labelsText = ["Você não possui relatos passados ainda.", "Você não possui relatos atuais ainda."]
        
        if MyStoriesManager.instance.todosOsDados[segmentedControl.selectedSegmentIndex].count == 0 {
            self.noStoryLabel.alpha = 1
            self.noStoryLabel.text = labelsText[segmentedControl.selectedSegmentIndex]
        }
        
    }



    var segmentedControl: CustomSegmentedContrl!
    var selectedIndex:Int?
    var currentSegment:Int = 0
    var bool =  false

    //outlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var noStoryLabel: UILabel!
    @IBOutlet weak var pickYouTeaButton: UIButton!
    @IBOutlet weak var imageCircle: UIButton!

    var activityView:UIActivityIndicatorView!
    

    @IBAction func pickYourTeaButton(_ sender: Any) {
        performSegue(withIdentifier: "toChooseYourTea", sender: nil)
        imageCircle.alpha = 1
        profileImage.alpha = 1
        pickYouTeaButton.alpha = 0
        bool = false
    }
    
   

    //actions
    @IBAction func logoutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Deseja mesmo sair?", message: "", preferredStyle: .alert)
        
        
        let ok = UIAlertAction(title: "Sim, desejo sair", style: .default, handler: { (action) -> Void in
            
            try! Auth.auth().signOut()
            self.performSegue(withIdentifier: "main", sender: self)
            
        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(ok)
        alert.addAction(cancelar)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.buttonPink



    }


    @IBAction func editButton(_ sender: Any) {
        if bool == false{
        imageCircle.alpha = 0.25
        profileImage.alpha = 0.25
        pickYouTeaButton.alpha = 1
        bool = true
            
        }
        else{
            
            imageCircle.alpha = 1
            profileImage.alpha = 1
            pickYouTeaButton.alpha = 0
            bool = false
        }
        

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
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = UIColor.buttonPink
        activityView.frame = CGRect(x: 0, y: 0, width: 300.0, height: 300.0)
        activityView.center = segmentedControl.center
        activityView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        noStoryLabel.alpha = 0
        
        
        view.addSubview(activityView)
        
        activityView.startAnimating()

        Auth.auth().currentUser?.reload()
        
        MyStoriesManager.instance.loadMyStories(requester: self)
        
        self.currentSegment = 0
        
        self.profileTableView.isUserInteractionEnabled = true
        
        bool =  false
        
    }


    var dadosDaTableView = MyStoriesManager.instance.todosOsDados[0]

    //segmented control adjustments
    @objc func onChangeOfSegment(_ sender: CustomSegmentedContrl) {
        dadosDaTableView = MyStoriesManager.instance.todosOsDados[sender.selectedSegmentIndex]
        profileTableView.reloadData()
        self.currentSegment = sender.selectedSegmentIndex
        print(currentSegment)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "showStory", sender: nil)
    }

    //table view setting
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyStoriesManager.instance.todosOsDados[segmentedControl.selectedSegmentIndex].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileTableViewCell
        let docID = MyStoriesManager.instance.todosOsDados[segmentedControl.selectedSegmentIndex][indexPath.row]
        guard let conteudo = docID.data()["conteudo"] as? String else {
            return profileCell
        }
        profileCell.profileCellTextField.text = conteudo
        profileCell.isUserInteractionEnabled = true
        return profileCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    

    func readedStories(stories: [QueryDocumentSnapshot]) {
        print("not here")
    }

//    func readedMyStories(stories: [QueryDocumentSnapshot]) {
//        print("readed my stories")
//        profileTableView.reloadData()
//        activityView.stopAnimating()
//
//        let labelsText = ["Você não possui relatos passados ainda.", "Você não possui relatos atuais ainda."]
//
//        if MyStoriesManager.instance.todosOsDados[segmentedControl.selectedSegmentIndex].count == 0 {
//            self.noStoryLabel.alpha = 1
//             self.noStoryLabel.text = labelsText[segmentedControl.selectedSegmentIndex]
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStory" {
            if let destinationVC = segue.destination as? StoryScreen{
                guard let selected = self.selectedIndex else {
                    return
                }
                if currentSegment == 0 {
                    destinationVC.selectedStory = MyStoriesManager.instance.relatosPassados[selected]
                } else {
                    destinationVC.selectedStory = MyStoriesManager.instance.relatosAtuais[selected]
                }
                
            }
        }
    }


}
