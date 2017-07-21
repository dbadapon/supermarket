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

    enum Field {
        case Name, Images, ItemDescription, Price, Condition, Negotiable, Latitude, Longitude
        
        var key: String {
            switch (self) {
            case .Name:
                return "name"
            case .Images:
                return "images"
            case .ItemDescription:
                return "itemDescription"
            case .Price:
                return "price"
            case .Condition:
                return "conditionNew"
            case .Negotiable:
                return "negotiable"
            case .Latitude:
                return "latitude"
            case .Longitude:
                return "longitude"
            }
        }
    }
    
    var name: String? { // so why do all of these things have to be optional?
        get {
            return parseObject[Field.Name.key] as? String
        }
        set {
            parseObject[Field.Name.key] = newValue
        }
    }
    
    var itemDescription: String? {
        get {
            return parseObject[Field.ItemDescription.key] as? String
        }
        set {
            parseObject[Field.ItemDescription.key] = newValue
        }
    }
    
    var price: Double? {
        get {
            return parseObject[Field.Price.key] as? Double
        }
        set {
            parseObject[Field.Price.key] = newValue
        }
    }
    
    var conditionNew: Bool? {
        get {
            return parseObject[Field.Condition.key] as? Bool
        }
        set {
            parseObject[Field.Condition.key] = newValue
        }
    }
    
    var negotiable: Bool? {
        get {
            return parseObject[Field.Negotiable.key] as? Bool
        }
        set {
            parseObject[Field.Negotiable.key] = newValue
        }
    }
    
    var latitude: Double? {
        get {
            return parseObject[Field.Latitude.key] as? Double
        }
        set {
            parseObject[Field.Latitude.key] = newValue
        }
    }
    
    var longitude: Double? {
        get {
            return parseObject[Field.Longitude.key] as? Double
        }
        set {
            parseObject[Field.Latitude.key] = newValue
        }
    }
    
    var images: [PFFile]? {
        get {
            return parseObject[Field.Images.key] as? [PFFile]
        }
        set {
            parseObject[Field.Images.key] = newValue
        }
    }

    
//    private (set)
    var parseObject: PFObject
    
    init(_ parseObject: PFObject? = nil) {
        self.parseObject = parseObject ?? PFObject(className: "Post")
    }


    class func postItem(images: [UIImage], name: String, itemDescription: String, price: Double, conditionNew: Bool, negotiable: Bool, latitude: Double, longitude: Double)  {
        
//        let newPost = Post()
//        newPost.name = "Alvin"
//        let postKey = Post.Field.Name.key
        
        let newPost = Post()
        
        newPost.name = name
        
        newPost.itemDescription = itemDescription
        
        newPost.price = price
        
        newPost.conditionNew = conditionNew
        
        newPost.negotiable = negotiable
        
        newPost.latitude = latitude
        
        newPost.longitude = latitude
        
        var convertedImages: [PFFile] = []
        for image in images {
            convertedImages.append(Post.getPFFileFromImage(image: image)!)
        }
        newPost.images = convertedImages
        
        
        
        newPost.parseObject.saveInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("the post should have saved!")
            }
        }
        
    
        
//        if let images = images {
//            var convertedImages: [PFFile]? = []
//            for image in images {
//                convertedImages?.append(Post.getPFFileFromImage(image: image)!)
//            }
//            post["images"] = convertedImages
//        } else {
//            post["images"] = NSNull()
//        }
//        post["name"] = name
//        post["itemDescription"] = itemDescription
//        post["price"] = price
//        post["conditionNew"] = conditionNew
//        post["negotiable"] = negotiable
//        post["latitude"] = latitude
//        post["longitude"] = longitude
        
        
//        post.saveInBackground { (success: Bool, error: Error?) in
//            if let error = error {
//                print (error.localizedDescription)
//                
//            } else {
//                print ("the post should have saved!")
//            }
//        }
    
//        return post
        
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
    
    
}
