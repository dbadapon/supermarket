//
//  BuyFeedCell.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BuyFeedCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    
    
    @IBOutlet weak var itemImageView: PFImageView!

    var itemImage: PFObject! {
        didSet{
            let images: [PFFile]? = itemImage["images"] as! [PFFile]
            let file = images![0] as? PFFile
            self.itemImageView.file = file
            self.itemImageView.loadInBackground()
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
