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
        
        var buyFeedStoryboard = UIStoryboard(name: "BuyFeed", bundle: nil)
        
        var buyFeedController = buyFeedStoryboard.instantiateViewController(withIdentifier: "BuyFeedController") as! UINavigationController
        
        let controllers = [buyFeedController]
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
