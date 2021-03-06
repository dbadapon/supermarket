//
//  DetailPictureCell.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ZKCarousel

class DetailPictureCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    var totalImages: [UIImage] = []
    @IBOutlet weak var carouselView: ZKCarousel!
    
    
    var postImage: PFObject! {
        didSet {
            let images: [PFFile]? = postImage["images"] as? [PFFile]
            let file = images![0] as? PFFile
            self.postImageView.file = file
            self.postImageView.loadInBackground()
            
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        automaticallyAdjustsScrollViewInsets = false
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
