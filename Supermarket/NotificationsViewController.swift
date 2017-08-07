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
    
    let ourColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
    
    var clickedPost: Post!
    
    var loadAgain: Bool?
    
    
    
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
        
        
        
        
        self.navigationItem.title = "Alerts"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor.black]

        navigationController?.navigationBar.barStyle = UIBarStyle.default
        
        // navigationController?.navigationBar.isTranslucent = false
        
        automaticallyAdjustsScrollViewInsets = false
        
        
        self.tableView.tableFooterView = UIView()
        
        tableView.reloadData()
        tableView.reloadData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if self.loadAgain != nil {
            print ("it will not load again")
            self.loadAgain = nil
        } else {
        print ("it's at view will appear")
        var query = PFQuery(className: "SupermarketNotification")
        query.whereKey("receiver", equalTo: PFUser.current())
        query.addDescendingOrder("createdAt")
        query.includeKey("sender")
        query.includeKey("postObject")
        query.limit = 20
        
        query.findObjectsInBackground { (notifications: [PFObject]?, error: Error?) in
            if let notifications = notifications {
                // print ("it found notifications")
                print (notifications.count)
                var newNotifications: [SupermarketNotification] = []
                for item in notifications {
                    let notification = SupermarketNotification(item)
                    newNotifications.append(notification)
                }
                self.notifications = newNotifications
                self.tableView.reloadData()
            } else if error != nil {
                print("Error with query.findObjectsInBackground")
                // print (error?.localizedDescription)
            } else {
                // print ("the posts could not be loaded into the sell feed")
            }
        }
        
            print ("finishes view will appear")
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
        
        let notification = notifications[indexPath.row]
        
        let date = notification.parseObject.createdAt
        let dateString = Post.getRelativeDate(date: date!)
        cell.dateLabel.text = dateString
        print ("getting to notification did set method")
        let sender = notification.sender
        print (sender)
        let post = Post(notification.postObject)
        
        let senderName = notification.sender["username"] as! String
        let postName = notification.postObject["name"] as! String
        let message = notification.message
        
        if notification.message == " is interested in your " {
            let firstPart = "'" + senderName
            let secondPart = "'" + message
            let thirdPart = postName + "."
            let messageText = firstPart + secondPart + thirdPart
            cell.messageLabel.text = messageText
            
            cell.ignoreButton.setTitle("Dismiss", for: .normal)
            
            cell.respondButton.frame.size.width = 0
            cell.respondButton.frame.size.height = 0
            cell.respondButton.alpha = 0
            cell.respondButton.isEnabled = false
            
        } else if notification.message == " wants to ask about your " {
            let firstPart = "'" + senderName
            let secondPart = "'" + message
            let thirdPart = postName + "."
            let messageText = firstPart + secondPart + thirdPart
            cell.messageLabel.text = messageText
            
        } else {
            cell.messageLabel.text = notification.message
            
            cell.ignoreButton.setTitle("Dismiss", for: .normal)
            
            cell.respondButton.frame.size.width = 0
            cell.respondButton.frame.size.height = 0
            cell.respondButton.alpha = 0
            cell.respondButton.isEnabled = false
        }
        
        let images = post.images as! [PFFile]
        cell.postPhotoImage.file = images[0]
        cell.postPhotoImage.loadInBackground()
            
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
        // print (indexPath.row)
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
                            // print ("the notification should have been deleted")
                        }
                    })
                }
            } else {
                // print ("it could not find the notification, but there was no error")
            }
        }
    }
    
    func didTapMessage(of notification: SupermarketNotification, indexPath: IndexPath) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        let number = notification.sender["phoneNumber"] as? String
        let recipients = [number]
        composeVC.recipients = recipients as? [String]
        
        let initialString = "Hey, I saw that you were interested in my "
        let name = notification.postObject["name"] as? String
        let finalString = ". Do you want to talk further about it?"
        composeVC.body = initialString + name! + finalString
        
        self.indexPath = indexPath
        self.notification = notification
        
        
        // Present the view controller modally.
        self.present(composeVC, animated: true) {
            self.loadAgain = false
            
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true) {
            print ("gets to the closure")
            if result.rawValue == 1 {
                print ("it was successful")
                self.notifications.remove(at: (self.indexPath?.row)!)
                var indexPaths: [IndexPath] = []
                indexPaths.append(self.indexPath!)

                self.tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
                let query = PFQuery(className: "SupermarketNotification")
                query.whereKey("sender", equalTo: self.notification!.sender)
                query.whereKey("receiver", equalTo: self.notification!.receiver)
                query.findObjectsInBackground { (notifications, error) in
                    if let error = error {
                        print ("there was an error finding the notification \(error.localizedDescription)")
                    } else if let notifications = notifications {
                        // print (notifications.count)
                        for item in notifications {
                            item.deleteInBackground(block: { (success, error) in
                                if let error = error {
                                    print ("there was an error with deleting the notification \(error.localizedDescription)")
                                } else {
                                    // print ("the notification should have been deleted")
                                }
                            })
                        }
                    } else {
                        // print ("it could not find the notification, but there was no error")
                    }
                }
                
            } else {
                // print ("something else happened")
            }
            
        }
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "notificationToDetail" {
            let destination = segue.destination as! NewDetailViewController
            destination.post = self.clickedPost
        }
    }
    

}
