//
//  MarketCell.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class MarketCell: UITableViewCell {

    @IBOutlet weak var marketName: UILabel!
    var market: Market?
    weak var delegate: MarketCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onInfo(_ sender: Any) {
        delegate?.didTapInfo(of: market!)
    }
    
}
