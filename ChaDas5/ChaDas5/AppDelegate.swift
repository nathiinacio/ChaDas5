//
//  AppDelegate.swift
//  ChaDas5
//
//  Created by Julia Maria Santos on 26/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        FBRef.db = Firestore.firestore()
        let settings = FBRef.db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        FBRef.db.settings = settings
        
        if Auth.auth().currentUser != nil {
            UserManager.instance.setup()
        }
        
//        UserDefaults.standard.set(["pt_BR"], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//
//        UNUserNotificationCenter.current().requestAuthorization(options: [.badge , .alert]) { (sucess, error) in
//            if error != nil{
//
//                print("Authorizatiion Unsucessful")
//
//            }
//            else{
//
//                print("Authorizatiion Sucessful")
//
//            }
//        }
        
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
    
   
    
}
