//
//  AppDelegate.swift
//  EngagingChoice
//
//  Created by shahwalkhan@gmail.com on 09/01/2018.
//  Copyright (c) 2018 shahwalkhan@gmail.com. All rights reserved.
//

import UIKit
import EngagingChoice
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var emailAddres:String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        ECGridManager.shared.config(secretKey: "300f2011c-9024-4bc0-9351-1ba9fced7d4f") //QA
        //        ECGridManager.shared.config(secretKey: "118c871ff76-4d9c-4eef-8a32-2b8b7cebf524") //QA2
//        ECGridManager.shared.config(secretKey: "785fd63a7c-1a8b-4d52-a42f-011c5324a981") // QA3
       // ECGridManager.shared.config(secretKey: "26ecd3a7b1-f7dc-4e34-b722-dab240db4bcb") // Staging
//        ECGridManager.shared.config(secretKey: "5b0b6110c-d3c5-47a3-a155-6887c210cc03") // Beta
//        ECGridManager.shared.config(secretKey: "5953e1161-584a-45c9-b6c1-5cb174430151") // QA
        ECGridManager.shared.config(secretKey: "1323db439ce-809d-40e1-89ac-f8aad4eb8e9d") // QA
        
//                ECGridManager.shared.config(secretKey: "3258c0da8-38db-431f-a062-e44a59725c02") // Staging
//        ECGridManager.shared.config(secretKey: "5d89d23dc-05db-4c47-8ad0-fc98e1d8f20b") // Load testing
//        ECGridManager.shared.config(secretKey: "7041bd0a0-b639-4d1c-9f34-e73e19236c15") // STAGING
        UINavigationBar.appearance().barTintColor = UIColor(red: 61/255, green: 106/255, blue: 211/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

