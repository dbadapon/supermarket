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

class Post {
    
    var images: [PFFile]?
    var name: String
    var description: String
    var price: Double
    var conditionNew: Bool
    var negotiable: Bool
    var exchange: [String]?
    var transport: [String]?
    var location: CLLocationCoordinate2D
    
    
    init(images: [UIImage]?, name: String, description: String?, price: Double, conditionNew: Bool, negotiable: Bool, exchange: [String]?, transport: [String]?, location: CLLocationCoordinate2D) {
        var convertedImages: [PFFile]? = []
        if let images = images {
            for image in images {
                let file = Post.getPFFileFromImage(image: image)
                convertedImages?.append(file!)
            }
        }
        self.images = convertedImages
        
        self.name = name
        self.description = description!
        self.price = price
        self.conditionNew = conditionNew
        self.negotiable = negotiable
        self.exchange = exchange
        self.transport = transport
        self.location = location
    }
    
    
//    /**
//     * Other methods
//     */
//    
//    /**
//     Method to add a user post to Parse (uploading image file)
//     
//     - parameter image: Image that the user wants upload to parse
//     - parameter caption: Caption text input by the user
//     - parameter completion: Block to be executed after save operation is complete
//     */
//    class func postUserItem(images: [UIImage]?, withName name: String, withDescription description: String?, withPrice price: Double, withConditionNew conditionNew: Bool, withNegotiable negotiable: Bool, withExchange exchange: [String]?, withTransport transport: [String]?, withCompletion completion: PFBooleanResultBlock?) {
//        // Create Parse object PFObject
//        let post = PFObject(className: "Post")
//        
//        // Add relevant fields to the object
//        var convertedImages: [PFFile] = []
//        if let images = images {
//            for image in images {
//                convertedImages.append(getPFFileFromImage(image: image)!)
//            }
//        }
//        
//        post["media"] = convertedImages // PFFile column type
//        post["seller"] = PFUser.current() // Pointer column type that points to PFUser
//        post["description"] = description
//        post["interestedCount"] = 0
//        var interestedList: [PFUser] = []
//        post["interestedList"] = interestedList
//        post["price"] = price
//        post["name"] = name
//        var buyer: PFUser? = nil
//        post["buyer"] = buyer
//        post["exchange"] = exchange
//        post["transport"] = transport
//        
//        
//        // Save object (following function will save the object in Parse asynchronously)
//        post.saveInBackground(block: completion)
//    }
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
    
    func addImage(image: UIImage) {
        let convertedImage = Post.getPFFileFromImage(image: image)
        self.images?.append(convertedImage!)
    }
    
}
