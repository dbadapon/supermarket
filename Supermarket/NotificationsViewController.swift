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
    func didTapIgnore(of notification: SupermarketNotification, indexPath: IndexPath)
    func didTapMessage(of notification: SupermarketNotification, indexPath: IndexPath)
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InterestedCellDelegate, MFMessageComposeViewControllerDelegate {
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [SupermarketNotification] = []
    
    var notification: SupermarketNotification? = nil
    var indexPath: IndexPath? = nil
    // var messages: [Message]? = nil
    
    let ourColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
    
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
        
        
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        
        self.tableView.tableFooterView = UIView()
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var query = PFQuery(className: "SupermarketNotification")
        query.whereKey("receiver", equalTo: PFUser.current())
        query.addDescendingOrder("createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (notifications: [PFObject]?, error: Error?) in
            if let notifications = notifications {
                print ("it found notifications")
                print (notifications.count)
                var newNotifications: [SupermarketNotification] = []
                for item in notifications {
                    let notification = SupermarketNotification(item)
                    newNotifications.append(notification)
                }
                self.notifications = newNotifications
                self.tableView.reloadData()
                self.tableView.reloadData()
            } else if error != nil {
                print (error?.localizedDescription)
            } else {
                print ("the posts could not be loaded into the sell feed")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterestedCell") as! InterestedCell
            
            cell.notification = notifications[indexPath.row]
            cell.delegate = self
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didTapPhoto(of post: Post) {
        self.clickedPost = post
        self.performSegue(withIdentifier: "notificationToDetail", sender: self)
    }
    
    func didTapIgnore(of notification: SupermarketNotification, indexPath: IndexPath) {
        print (indexPath.row)
        var indexPaths: [IndexPath] = []
        indexPaths.append(indexPath)
        notifications.remove(at: indexPath.row)
        tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        let query = PFQuery(className: "SupermarketNotification")
        query.whereKey("sender", equalTo: notification.sender)
        query.whereKey("receiver", equalTo: notification.receiver)
        query.findObjectsInBackground { (notifications, error) in
            if let error = error {
                print ("there was an error finding the notification \(error.localizedDescription)")
            } else if let notifications = notifications {
                print (notifications.count)
                for item in notifications {
                    item.deleteInBackground(block: { (success, error) in
                        if let error = error {
                            print ("there was an error with deleting the notification \(error.localizedDescription)")
                        } else {
                            print ("the notification should have been deleted")
                        }
                    })
                }
            } else {
                print ("it could not find the notification, but there was no error")
            }
        }
    }
    
    func didTapMessage(of notification: SupermarketNotification, indexPath: IndexPath) {
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
        self.notification = notification
        self.indexPath = indexPath
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            if result.rawValue == 1 {
                var indexPaths: [IndexPath] = []
                indexPaths.append(self.indexPath!)
                print (self.notifications)
                self.notifications.remove(at: self.indexPath!.row)
                self.tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
                
                let query = PFQuery(className: "SupermarketNotification")
                query.whereKey("sender", equalTo: self.notification?.sender)
                query.whereKey("receiver", equalTo: self.notification?.receiver)
                query.findObjectsInBackground { (notifications, error) in
                    if let error = error {
                        print ("there was an error finding the notification \(error.localizedDescription)")
                    } else if let notifications = notifications {
                        print (notifications.count)
                        for item in notifications {
                            item.deleteInBackground(block: { (success, error) in
                                if let error = error {
                                    print ("there was an error with deleting the notification \(error.localizedDescription)")
                                } else {
                                    print ("the notification should have been deleted")
                                }
                            })
                        }
                    } else {
                        print ("it could not find the notification, but there was no error")
                    }
                }
            } else {
                print ("something else happened")
            }
            
        }
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
