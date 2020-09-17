//
//  AppDelegate.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/11.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var tabbarC = BaseTabbarC.init()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        self.window?.rootViewController = tabbarC
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

