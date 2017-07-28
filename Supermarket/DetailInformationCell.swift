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
    
    var post: Post!
    
    
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
        let notification = SupermarketNotification.createNotification(withSender: PFUser.current()!, withReceiver: PFUser.current()!, withMessage: " is interested in your ", withPostObject: post.parseObject)
    }
}
