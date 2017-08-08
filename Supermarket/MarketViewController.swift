//
//  MarketViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/24/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import RAMAnimatedTabBarController

class MarketViewController: UIViewController {

    var market: Market!
    
    @IBOutlet weak var marketProfileImage: PFImageView!
    @IBOutlet weak var marketNameLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var marketDescriptionLabel: UILabel!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var leaveMarketButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
//        animatedTabBar.animationTabBarHidden(true)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient")!)
        
        inviteFriendsButton.layer.cornerRadius = inviteFriendsButton.frame.width * 0.03
        inviteFriendsButton.layer.masksToBounds = true
        inviteFriendsButton.backgroundColor = UIColor.white
        
        leaveMarketButton.layer.cornerRadius = leaveMarketButton.frame.width * 0.03
        leaveMarketButton.layer.masksToBounds = true
        leaveMarketButton.backgroundColor = .clear
        leaveMarketButton.layer.cornerRadius = 5
        leaveMarketButton.layer.borderWidth = 1
        leaveMarketButton.layer.borderColor = UIColor.white.cgColor
        
        marketProfileImage.layer.cornerRadius = marketProfileImage.frame.width * 0.5
        marketProfileImage.layer.masksToBounds = true
        marketProfileImage.layer.borderWidth = 5
        marketProfileImage.layer.borderColor = UIColor.white.cgColor
        
        
        marketProfileImage.file = market.profileImage!
        marketProfileImage.loadInBackground()
        
        
        marketNameLabel.text = market.name
        
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        memberCountLabel.text = String(describing: market.memberCount!)
        marketDescriptionLabel.text = market.description!
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
//        animatedTabBar.animationTabBarHidden(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
