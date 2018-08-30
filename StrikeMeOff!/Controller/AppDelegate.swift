//
//  AppDelegate.swift
//  StrikeMeOff!
//
//  Created by Sidhant Chadha on 8/23/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        

        
        do {
             _ = try Realm()
     
            }
            
        catch {
            print("Error initializing Realm")
        }
        

        return true
    }


   

}

