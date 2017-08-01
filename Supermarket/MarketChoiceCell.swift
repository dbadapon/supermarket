//
//  MarketChoiceCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/27/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class MarketChoiceCell: UICollectionViewCell {
    
    @IBOutlet weak var marketProfileImage: PFImageView!
    @IBOutlet weak var marketName: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        marketProfileImage.layer.cornerRadius = marketProfileImage.frame.height/2
        marketProfileImage.layer.masksToBounds = true
        marketProfileImage.layer.borderWidth = 5
        marketProfileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    
}
