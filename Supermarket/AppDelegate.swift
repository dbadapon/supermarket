//
//  AppDelegate.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /*
     NotificationCenter.default.addObserver(forName: Notification.Name("didLogout"), object: nil, queue: OperationQueue.main) { (Notification) in
     print("Logout notification received")
     // TODO: Logout the User
     // TODO: Load and show the login view controller
     }
     
     func logOut() {
     // Logout the current user
     PFUser.logOutInBackground(block: { (error) in
     if let error = error {
     print(error.localizedDescription)
     } else {
     print("Successful loggout")
     // Load and show the login view controller
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     let loginViewController = storyboard.instantiateViewController(withIdentifier: "PUT_YOUR_LOGIN_VC_ID_HERE")
     self.window?.rootViewController = loginViewController
     }
     })
     }
     */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
//        IQKeyboardManager.sharedManager().enable = true
        
        // This is the only line of code you need to manually add
        // in order for IQKeybaordManager to work. Thats it.
        let sharedKeyboardManager = IQKeyboardManager.sharedManager()
        sharedKeyboardManager.enable = true
        sharedKeyboardManager.shouldResignOnTouchOutside = true
        sharedKeyboardManager.enableAutoToolbar = false
        
        
        

        
        //        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Supermarket"
                configuration.clientKey = "randomMasterKey101"  // set to nil assuming you have not set clientKey
                configuration.server = "https://whispering-island-66333.herokuapp.com/parse"
            })
        )
        
//        PFUser.logOutInBackground { (error) in
//            print (PFUser.current())
//        }
        
        PFUser.logInWithUsername(inBackground: "TeamTriceratops", password: "password", block: { (user: PFUser?, error: Error?) in
            if let error = error {
                let errorInfo = error._userInfo as! [String: Any]
                let code = errorInfo["code"] as! Int
                if code == 101 {

                }

            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login

            }
        })
        
        
//        let newUser = PFUser()
//        newUser.username = "anotherUser"
//        newUser.password = "password"
//
//        newUser.signUpInBackground { (success: Bool, error: Error?) in
//            if let error = error {
//                let errorInfo = error._userInfo as! [String: Any]
//                let code = errorInfo["code"] as! Int
//                if code == 202 {
//                }
//            } else {
//                print("User Registered successfully")
//                    // manually segue to logged in view
//            }
//        }
        // check if user is logged in.
        
//        if let currentUser = PFUser.current() {
//            print("Welcome back \(currentUser.username!) 😀")
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//            // TabBarController is storyboard ID
//            window?.rootViewController = tabBarController
//        } else {
//            print ("there was no current user")
//        }
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

