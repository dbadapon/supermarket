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
        
        self.categoryLabel.textColor = UIColor.white
        
        
//        self.layer.masksToBounds = false
//        self.clipsToBounds = false
//        self.layer.shadowOpacity = 0.9
//        self.layer.shadowRadius = 5.0
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowColor = Constants.Colors.ourGray.cgColor
//        self.layer.shadowPath = UIBezierPath(
        
    }
    
    
}
