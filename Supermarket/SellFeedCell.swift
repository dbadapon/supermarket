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
    
      @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var photoImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    

    var post: Post! {
        didSet {
//                let date = post.parseObject.createdAt
//            let dateString = Post.getRelativeDate(date: date!)
//            self.dateLabel.text = dateString
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = .short
//                dateFormatter.timeStyle = .none
//                let dateString = dateFormatter.string(from: date!)
            
                let name = post.name
            self.nameLabel.text = name
                
                let price = post.price
            let formattedPrice = String(format: "%.2f", price!)
                self.priceLabel.text = "$" + formattedPrice
                
            let images = post.images
            self.photoImage.file = images?[0]
            self.photoImage.loadInBackground()
                
//                self.dateLabel.text = "Posted " + dateString
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.layer.borderWidth = 1
        photoImage.layer.borderColor = Constants.Colors.ourGray.cgColor
        photoImage.layer.cornerRadius = 2
        
        whiteView.layer.borderWidth = 1
        whiteView.layer.borderColor = Constants.Colors.ourGray.cgColor
        whiteView.layer.cornerRadius = 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
