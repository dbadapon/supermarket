//
//  InterestedCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class InterestedCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var respondButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var postPhotoImage: PFImageView!
    weak var delegate: InterestedCellDelegate?
    var post: Post!
    
    var notification: SupermarketNotification! {
        didSet {
//            let date = notification.parseObject.createdAt
//            let dateString = Post.getRelativeDate(date: date!)
//            dateLabel.text = dateString
//            print ("getting to notification did set method")
//            let sender = notification.sender
//            print (sender)
//            post = Post(notification.postObject)
//
//            let senderName = notification.sender["username"] as! String
//            let postName = notification.postObject["name"] as! String
//            let message = notification.message
//
//            if self.notification.message == " is interested in your " {
//                let firstPart = "'" + senderName
//                let secondPart = "'" + message
//                let thirdPart = postName + "."
//                let messageText = firstPart + secondPart + thirdPart
//                self.messageLabel.text = messageText
//
//                self.ignoreButton.setTitle("Dismiss", for: .normal)
//
//                self.respondButton.frame.size.width = 0
//                self.respondButton.frame.size.height = 0
//                self.respondButton.alpha = 0
//                self.respondButton.isEnabled = false
//
//            } else if self.notification.message == " wants to ask about your " {
//                let firstPart = "'" + senderName
//                let secondPart = "'" + message
//                let thirdPart = postName + "."
//                let messageText = firstPart + secondPart + thirdPart
//                self.messageLabel.text = messageText
//
//            } else {
//                self.messageLabel.text = self.notification.message
//
//                self.ignoreButton.setTitle("Dismiss", for: .normal)
//
//                self.respondButton.frame.size.width = 0
//                self.respondButton.frame.size.height = 0
//                self.respondButton.alpha = 0
//                self.respondButton.isEnabled = false
//            }
//
//            let images = self.post.images as! [PFFile]
//            self.postPhotoImage.file = images[0]
//            self.postPhotoImage.loadInBackground()
            
//            sender.fetchInBackground { (sender, error) in
//                if let error = error {
//                    print ("this is the error for sender: \(error.localizedDescription)")
//                } else {
//                    senderName = sender!["username"] as! String
//
//                    let post = self.notification.postObject
//                    post.fetchInBackground(block: { (post, error) in
//                        if let error = error {
//                            print ("this is the post error \(error.localizedDescription)")
//                        } else {
//                            self.post = Post(post)
//                            print ("it's actually getting here")
//                            postName = self.post.name as! String
//
//
//
//                        }
//                    })
//
//                }
//            }
            
        }
    }
    
    var indexPath: IndexPath? {
        return (superview as? UITableView)?.indexPath(for: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ignoreButton.layer.cornerRadius = ignoreButton.frame.width * 0.05
        ignoreButton.layer.masksToBounds = true
        
        respondButton.layer.cornerRadius = respondButton.frame.width * 0.05
        respondButton.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didPressPhoto(_ sender: Any) {
        print ("did select photo")
        self.delegate?.didTapPhoto(of: self.post)
    }
    
    @IBAction func didPressRespond(_ sender: Any) {
        print ("did press respond")
        self.delegate?.didTapMessage(of: notification, indexPath: self.indexPath!)
    }
    
    @IBAction func didPressIgnore(_ sender: Any) {
        print ("did press ignore")
        self.delegate?.didTapIgnore(of: notification, indexPath: self.indexPath!)
    }
    
    @IBAction func didPressProfile(_ sender: Any) {
        print ("did press profile")
        self.delegate?.didTapProfile(of: notification.sender)
    }
    

}
