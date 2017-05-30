//
//  AppDelegate.swift
//  WatsonDemo
//
//  Created by RAHUL on 11/13/16.
//  Copyright © 2016 RAHUL. All rights reserved.
//

import UIKit
import BoxContentSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        let defaultValues = ["":"UserDetail"]
        
        _ = BOXContentClient.self.setClientID("2y3f7wr99x1emxgwuaufiwku9km19kna", clientSecret: "5xCJXqmPgliUNZbFCd87R859d1OURER2")

        defaults.register(defaults: defaultValues)
        //defaults.registerDefaults(defaultValues)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signInVc = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        self.window?.rootViewController = signInVc
        
        // Override point for customization after application launch.
        return true
    }

}

