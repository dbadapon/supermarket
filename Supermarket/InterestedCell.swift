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

    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var respondButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var postPhotoImage: PFImageView!
    
    var notification: SupermarketNotification! {
        didSet {
            print ("getting to notification did set method")
            let sender = notification.sender
            print (sender)
            var senderName: String = ""
            var postName: String = ""
            sender.fetchInBackground { (sender, error) in
                if let error = error {
                    print ("this is the error for sender: \(error.localizedDescription)")
                } else {
                    senderName = sender!["username"] as! String
                    
                    let post = self.notification.postObject
                    post.fetchInBackground(block: { (post, error) in
                        if let error = error {
                            print ("this is the post error \(error.localizedDescription)")
                        } else {
                            let post = Post(post)
                            print ("it's actually getting here")
                            postName = post.name as! String
                            self.messageLabel.text = senderName + self.notification.message + postName
                            let images = post.images as! [PFFile]
                            self.postPhotoImage.file = images[0] as! PFFile
                            self.postPhotoImage.loadInBackground()
                            
                            
                        }
                    })
                    
                }
            }
            
        }
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

}
