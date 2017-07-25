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

class MarketViewController: UIViewController {

    var market: Market!
    
    @IBOutlet weak var marketProfileImage: PFImageView!
    @IBOutlet weak var marketNameLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var marketDescriptionLabel: UILabel!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var leaveMarketButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "MarketBackground.jpg")!)
        
        inviteFriendsButton.layer.cornerRadius = inviteFriendsButton.frame.width * 0.05
        inviteFriendsButton.layer.masksToBounds = true
        
        leaveMarketButton.layer.cornerRadius = leaveMarketButton.frame.width * 0.05
        leaveMarketButton.layer.masksToBounds = true
        
        marketProfileImage.layer.cornerRadius = marketProfileImage.frame.width * 0.5
        marketProfileImage.layer.masksToBounds = true
        
        
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
