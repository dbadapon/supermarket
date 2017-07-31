//
//  NotificationsViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import MessageUI

protocol InterestedCellDelegate: class {
    func didTapPhoto(of post: Post)
    func didTapIgnore(of notification: SupermarketNotification)
    func didTapMessage(of notification: SupermarketNotification)
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InterestedCellDelegate, MFMessageComposeViewControllerDelegate {
    
    
    
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [SupermarketNotification] = []
    
    // var messages: [Message]? = nil
    
    let ourColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var lineViewOne: UIView!
    @IBOutlet weak var lineViewTwo: UIView!
    var clickedPost: Post!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make sure tab bar is there
        self.tabBarController?.tabBar.isHidden = false

        // Do any additional setup after loading the view.
        
//        navigationController?.navigationBar.titleTextAttributes = [
//            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
//        ]
//        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        var query = PFQuery(className: "SupermarketNotification")
        query.whereKey("receiver", equalTo: PFUser.current())
        query.addDescendingOrder("createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (notifications: [PFObject]?, error: Error?) in
            if let notifications = notifications {
                print ("it found notifications")
                print (notifications.count)
                for item in notifications {
                    let notification = SupermarketNotification(item)
                    self.notifications.append(notification)
                }
                print (self.notifications)
                self.tableView.reloadData()
            } else if error != nil {
                print (error?.localizedDescription)
            } else {
                print ("the posts could not be loaded into the sell feed")
            }
        }
        
        lineViewOne.backgroundColor = ourColor
        lineViewTwo.backgroundColor = UIColor.clear
        
        segmentedControl.tintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        segmentedControl.layer.masksToBounds = true
        
        segmentedControl.tintColor = UIColor.clear
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : ourColor,
            NSFontAttributeName as NSObject: UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        ]
        segmentedControl.setTitleTextAttributes(boldTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(boldTextAttributes, for: .normal)
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        
        self.tableView.tableFooterView = UIView()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return notifications.count
        } else {
//            if let messages = self.messages {
//                return messages.count
//            } else {
//                return 0
//            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterestedCell") as! InterestedCell
            
            cell.notification = notifications[indexPath.row]
            cell.delegate = self
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
            return cell
        }
    }

    @IBAction func indexChanged(_ sender: Any) {

        if segmentedControl.selectedSegmentIndex == 0 {
            self.title = "Notifications"
            lineViewOne.backgroundColor = ourColor
            lineViewTwo.backgroundColor = UIColor.clear
            
        } else {
            self.title = "Messages"
            lineViewOne.backgroundColor = UIColor.clear
            lineViewTwo.backgroundColor = ourColor
        }
        
        tableView.reloadData()
    }
    
    func didTapPhoto(of post: Post) {
        self.clickedPost = post
        self.performSegue(withIdentifier: "notificationToDetail", sender: self)
    }
    
    func didTapIgnore(of notification: SupermarketNotification) {
        print ("ignore tapped")
    }
    
    func didTapMessage(of notification: SupermarketNotification) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        
        // Configure the fields of the interface.
        let number = notification.sender["phoneNumber"] as? String
        let recipients = [number]
        composeVC.recipients = recipients as! [String]
        
        let initialString = "Hey, I saw that you were interested in my "
        let name = notification.postObject["name"] as? String
        let finalString = ". Do you want to talk further about it?"
        composeVC.body = initialString + name! + finalString
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "notificationToDetail" {
            let destination = segue.destination as! DetailViewController
            destination.post = self.clickedPost
        }
    }
    

}
