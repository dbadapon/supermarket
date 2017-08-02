//
//  CategoryCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/27/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//       categoryNameLabel.textColor = UIColor.blue
//        print("Category name label is now: \(categoryNameLabel.text)")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
