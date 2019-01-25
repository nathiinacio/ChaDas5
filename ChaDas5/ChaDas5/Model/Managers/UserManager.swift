//
//  UserManager.swift
//  ChaDas5
//
//  Created by Julia Rocha on 20/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
    
    static let instance = UserManager()
    private init(){}
    
    var currentUser: String? = nil
    
    let teas = ["Gengibre", "Frutas Vermelhas", "Erva Doce", "Camomila", "Capim Limão", "Chá Preto", "Hibisco", "Hortelã"]
    
    func setup() {
        currentUser = Auth.auth().currentUser?.uid
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(error)
            }
            else{

                self.currentUser = user?.user.uid
                
                let docRef = FBRef.db.collection("users").document(self.currentUser!)
                
                docRef.getDocument { (document, error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    }
                    let property = document?.get("username") as! String
                    AppSettings.displayName = property
                    
                }
                completion(nil)
            }
       
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    
//    func fetchProviders(withEmail email: String, completion: @escaping (Error?) -> Void){
//
//        Auth.auth().fetchProviders(forEmail: email, completion: { (stringArray, error) in
//            if let error = error {
//                completion(error)
//            }
//
//            else{
//
//                if stringArray == nil{
//                    completion(nil)
//                    //criar usuario
//                }
//
//                else{
//                     completion(error)
//                }
//
//            }
//
//
//        })
//}
    
    
    
}

