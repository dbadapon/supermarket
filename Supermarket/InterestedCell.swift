//
//  InterestedCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class InterestedCell: UITableViewCell {

    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var respondButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var notification: Notification! {
        didSet {            
            let sender = notification.sender
            var senderName: String = ""
            var postName: String = ""
            sender.fetchInBackground { (sender, error) in
                if let error = error {
                    print (error.localizedDescription)
                } else {
                    senderName = sender!["username"] as! String
                    
                    let post = self.notification.postObject
                    post.fetchInBackground(block: { (post, error) in
                        if let error = error {
                            print (error.localizedDescription)
                        } else {
                            postName = post!["name"] as! String
                            self.messageLabel.text = senderName + self.notification.message + postName
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
