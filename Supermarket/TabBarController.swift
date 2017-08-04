//
//  TabBarController.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class TabBarController: RAMAnimatedTabBarController {
    
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        let tabAnimation = RAMBounceAnimation()
        tabAnimation.textSelectedColor = .red
        tabAnimation.iconSelectedColor = .red
        
        //        tabAnimation.textSelectedColor = .redColor()
        //        tabAnimation.iconSelectedColor = .redColor()
        
//        let tabBarItem = RAMAnimatedTabBarItem(title: "Example", image: UIImage(named: "Example"), selectedImage: nil)
//        tabBarItem.textColor = .blackColor()
//        tabBarItem.iconColor = .blackColor()
//        tabBarItem.animation = tabAnimation
        
        
        
        
        let buyFeedStoryboard = UIStoryboard(name: "BuyFeed", bundle: nil)
        let buyFeedController = buyFeedStoryboard.instantiateViewController(withIdentifier: "BuyFeedController") as! UINavigationController
        
        let tab1 = RAMAnimatedTabBarItem(title: "Buy", image: UIImage(named: "Shopping Cart-100"), selectedImage: nil)
        tab1.textColor = .black
        tab1.iconColor = .black
        tab1.animation = tabAnimation
        
//        let tab1 = UITabBarItem(title: "Buy", image: nil, selectedImage: nil)
//        let tab1 = RAMAnimatedTabBarItem(title: "Buy", image: nil, selectedImage: nil)
        buyFeedController.tabBarItem = tab1
        
        
        let sellFeedStoryboard = UIStoryboard(name: "SellFeed", bundle: nil)
        let sellFeedController = sellFeedStoryboard.instantiateViewController(withIdentifier: "SellFeedController") as! UINavigationController
        
        let tab2 = RAMAnimatedTabBarItem(title: "Sell", image: UIImage(named: "Price Tag USD-50"), selectedImage: nil)
        tab2.textColor = .black
        tab2.iconColor = .black
        tab2.animation = tabAnimation
        
//        let tab2 = UITabBarItem(title: "Sell", image: nil, selectedImage: nil)
//        let tab2 = RAMAnimatedTabBarItem(title: "Sell", image: nil, selectedImage: nil)
        sellFeedController.tabBarItem = tab2
        
        
        let createPostStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)
        let createPostController = createPostStoryboard.instantiateViewController(withIdentifier: "CreatePostController")
        
        let tab3 = RAMAnimatedTabBarItem(title: "Post", image: UIImage(named: "icons8-Add-50"), selectedImage: nil)
        tab3.textColor = .black
        tab3.iconColor = .black
        tab3.animation = tabAnimation
        
//        let tab3 = UITabBarItem(title: "Post", image: nil, selectedImage: nil)
        createPostController.tabBarItem = tab3
        
        
        
        
        let notificationStoryboard = UIStoryboard(name: "NotificationStoryboard", bundle: nil)
        let notificationController = notificationStoryboard.instantiateViewController(withIdentifier: "NotificationController") as! UINavigationController
        
        let tab4 = RAMAnimatedTabBarItem(title: "Alerts", image: UIImage(named: "icons8-Notification-50"), selectedImage: nil)
        tab4.textColor = .black
        tab4.iconColor = .black
        tab4.animation = tabAnimation
        
//        let tab4 = UITabBarItem(title: "Notifications", image: nil, selectedImage: nil)
        notificationController.tabBarItem = tab4
        
        
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! UINavigationController
        
        let tab5 = RAMAnimatedTabBarItem(title: "Profile", image: UIImage(named: "Customer-50"), selectedImage: nil)
        tab5.textColor = .black
        tab5.iconColor = .black
        tab5.animation = tabAnimation
        
//        let tab5 = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
        profileController.tabBarItem = tab5 
        
        
        
        
        let controllers = [buyFeedController, sellFeedController, createPostController, notificationController, profileController]
        self.viewControllers = controllers
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
