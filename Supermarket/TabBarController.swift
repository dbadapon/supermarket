//
//  TabBarController.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let buyFeedStoryboard = UIStoryboard(name: "BuyFeed", bundle: nil)
        let buyFeedController = buyFeedStoryboard.instantiateViewController(withIdentifier: "BuyFeedController") as! UINavigationController
        
        let tab1 = UITabBarItem(title: "Buy", image: nil, selectedImage: nil)
        buyFeedController.tabBarItem = tab1
        
        // change images later!
        
        
        let sellFeedStoryboard = UIStoryboard(name: "SellFeed", bundle: nil)
        let sellFeedController = sellFeedStoryboard.instantiateViewController(withIdentifier: "SellFeedController") as! UINavigationController
        
        let tab2 = UITabBarItem(title: "Sell", image: nil, selectedImage: nil)
        sellFeedController.tabBarItem = tab2
        
        
        let createPostStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)
        let createPostController = createPostStoryboard.instantiateViewController(withIdentifier: "CreatePostController") as! UINavigationController
        
        let tab3 = UITabBarItem(title: "Post", image: nil, selectedImage: nil)
        createPostController.tabBarItem = tab3
        
        let controllers = [buyFeedController, sellFeedController, createPostController]
        self.viewControllers = controllers
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
