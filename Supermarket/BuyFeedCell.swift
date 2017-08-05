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
    
    var isNew: Bool! {
        didSet {
            if isNew {
                newMark.isHidden = false
            } else {
                newMark.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var newMark: UIImageView!
    
    
    
    
    
    @IBOutlet weak var itemImageView: PFImageView!

    var itemImage: PFObject! {
        didSet{
            let images: [PFFile]? = itemImage["images"] as? [PFFile]
            let file = images![0]
            self.itemImageView.file = file
            self.itemImageView.loadInBackground()
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        itemImageView.layer.borderWidth = 1
        itemImageView.layer.borderColor = Constants.Colors.ourGray.cgColor
        itemImageView.layer.cornerRadius = 2
        
        whiteView.layer.borderWidth = 1
        whiteView.layer.borderColor = Constants.Colors.ourGray.cgColor
        whiteView.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
