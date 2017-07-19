//
//  SellFeedCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/19/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SellFeedCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    var post: PFObject! {
        didSet {
            post.fetchInBackground { (post: PFObject?, error: Error?) in
                if let post = post {
                    let date = post.createdAt
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .short
                    let dateString = dateFormatter.string(from: date!)
                    
                    self.dateLabel.text = "Posted " + dateString
                    
                    let name = post["name"]
                    self.nameLabel.text = name as? String
                    
                    let price = post["price"] as! Double
                    self.priceLabel.text = "$" + String(price)
                    
                    let images = post["images"] as! [PFFile]
                    self.photoImage.file = images[0]
                    self.photoImage.loadInBackground()
                    
                } else if error != nil {
                    print (error?.localizedDescription)
                    
                    
                } else {
                    print ("The sell feed cell is just not getting the post. no error though")
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

}
