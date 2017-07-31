//
//  DetailInformationCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse

class DetailInformationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var interestedButton: UIButton!
    var post: Post! {
        didSet {
            if let interestedList = post.parseObject["interested"] as? [String] {
                if interestedList.contains((PFUser.current()?.username)!) {
                    interestedButton.isSelected = true
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onMessage(_ sender: Any) {
    }
    
    @IBAction func onInterested(_ sender: Any) {
        interestedButton.isSelected = true
        let notification = SupermarketNotification.createNotification(withSender: PFUser.current()!, withReceiver: PFUser.current()!, withMessage: " is interested in your ", withPostObject: post.parseObject)
        
        let interested = post.parseObject["interested"] as? [String]
        if let interested = interested {
            var newInterested: [String] = []
            for username in interested {
                newInterested.append(username)
            }
            newInterested.append((PFUser.current()?.username)!)
            post.parseObject["interested"] = newInterested
        } else {
            let newInterested = [PFUser.current()?.username]
            post.parseObject["interested"] = newInterested
        }
        
        post.parseObject.saveInBackground { (success, error) in
            if let error = error {
                print ("there was an error with updating the interested array \(error.localizedDescription)")
            } else {
                print ("the interested array should have been updated correctly")
            }
        }
    }
}
