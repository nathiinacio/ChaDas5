//
//  AppDelegate.swift
//  ChaDas5
//
//  Created by Julia Maria Santos on 26/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import UIKit
import Firebase

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

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}
