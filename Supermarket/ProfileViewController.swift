//
//  ProfileViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/24/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController {

    var user: PFUser!
    
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make sure tab bar is there
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "MarketBackground")!)
        self.tabBarController?.tabBar.isHidden = false

        // Do any additional setup after loading the view.
        if user == nil {
            user = PFUser.current()!
        }
        
        navigationController?.isNavigationBarHidden = true
        
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.5
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        profileImage.file = user.value(forKey: "profileImage") as? PFFile
        profileImage.loadInBackground()
        
        fullNameLabel.text = user.value(forKey: "fullname") as? String
        usernameLabel.text = "@" + (user.value(forKey: "username") as! String)
        emailLabel.text = user.value(forKey: "email") as? String
        phoneNumberLabel.text = user.value(forKey: "phoneNumber") as? String
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
