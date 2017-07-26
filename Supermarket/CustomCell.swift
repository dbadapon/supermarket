//
//  CustomCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/26/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    var cellLabel: UILabel!
    
    init(frame: CGRect, title: String) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        cellLabel = UILabel(frame: frame)
        cellLabel.textColor = UIColor.black
        cellLabel.font = UIFont(name: "Avenir", size: 16)
        
        addSubview(cellLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
