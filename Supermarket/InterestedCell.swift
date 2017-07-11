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
