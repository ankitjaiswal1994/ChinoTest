//
//  AppDelegate.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SwiftyStoreKit
import FacebookCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var count = 0

   var navigationBarAppearance = UINavigationBar.appearance()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
       UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        navigationBarAppearance.barTintColor = .white
        navigationBarAppearance.isTranslucent = true
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.darkGray]
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        if UserDefaults.standard.integer(forKey: "launchCount") < 5 {
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "launchCount") + 1, forKey: "launchCount")
            let lastString = (UserDefaults.standard.integer(forKey: "launchCount") == 1) ? "" : "es"
            let countString = "\(UserDefaults.standard.integer(forKey: "launchCount"))" + " App Launch" + lastString
            AppEventsLogger.log(countString)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

