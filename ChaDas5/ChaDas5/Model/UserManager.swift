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
    
    let currentUser = Auth.auth().currentUser
    

}

