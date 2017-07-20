//
//  Post.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreLocation

class Post: NSObject {
    
//    var images: [PFFile]?
//    var name: String
//    var itemDescription: String
//    var price: Double
//    var conditionNew: Bool
//    var negotiable: Bool
//    var exchange: [String]?
//    var transport: [String]?
//    var location: CLLocationCoordinate2D?
//    
//    init(images: [UIImage]?, name: String, description: String?, price: Double, conditionNew: Bool, negotiable: Bool, exchange: [String]?, transport: [String]?, location: CLLocationCoordinate2D) {
//        var convertedImages: [PFFile]? = []
//        if let images = images {
//            for image in images {
//                let file = Post.getPFFileFromImage(image: image)
//                convertedImages?.append(file!)
//            }
//        }
//        self.images = convertedImages
//        
//        self.name = name
//        self.itemDescription = description!
//        self.price = price
//        self.conditionNew = conditionNew
//        self.negotiable = negotiable
//        self.exchange = exchange
//        self.transport = transport
//        self.location = location
//    }
//    
//    override init() {
//        var images: [UIImage]? = []
//        images?.append( UIImage(named: "insta_camera_btn")! )
//        images?.append( UIImage(named: "Menu-50")!)
//        var convertedImages: [PFFile]? = []
//        for image in images! {
//            let convertedImage = Post.getPFFileFromImage(image: image)!
//            convertedImages?.append(convertedImage)
//        }
//
//        name = "Foldable Chair"
//        itemDescription = "This is a new foldable chair. Really cool!"
//        price = 25.00
//        conditionNew = true
//        negotiable = true
//        exchange = ["Venmo", "Check", "Card"]
//        transport = ["Mail", "Car"]
//    }
//    
//    func addImage(image: UIImage) {
//        let convertedImage = Post.getPFFileFromImage(image: image)
//        self.images?.append(convertedImage!)
//    }

    class func postItem(images: [UIImage]?, name: String, itemDescription: String, price: Double, conditionNew: Bool, negotiable: Bool, latitude: Double, longitude: Double) -> PFObject? {
        
        let post = PFObject(className: "Post")
        
        if let images = images {
            var convertedImages: [PFFile]? = []
            for image in images {
                convertedImages?.append(Post.getPFFileFromImage(image: image)!)
            }
            post["images"] = convertedImages
        } else {
            post["images"] = NSNull()
        }
        post["name"] = name
        post["itemDescription"] = itemDescription
        post["price"] = price
        post["conditionNew"] = conditionNew
        post["negotiable"] = negotiable
        post["latitude"] = latitude
        post["longitude"] = longitude
        
        post.saveInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
                
            } else {
                print ("the post should have saved!")
            }
        }
    
        return post
        
    }
    
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
//    class func getID() {
//        return
//    }
    
}
