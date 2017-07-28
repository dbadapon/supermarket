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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        marketProfileImage.layer.cornerRadius = marketProfileImage.frame.width * 0.5
        marketProfileImage.layer.masksToBounds = true
    }
}