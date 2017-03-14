//
//  AppDelegate.swift
//  WatsonDemo
//
//  Created by Etay Luz on 11/13/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signInVc = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        self.window?.rootViewController = signInVc
        
        // Override point for customization after application launch.
        return true
    }

}

