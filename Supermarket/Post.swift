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
        case Name, Seller, Images, ItemDescription, Price, Condition, Negotiable, Latitude, Longitude, Sold, City, ID, Interested
        
        var key: String {
            switch (self) {
            case .Name:
                return "name"
            case .Seller:
                return "seller"
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
            case .Sold:
                return "sold"
            case .City:
                return "city"
            case .ID:
                return "id"
            case .Interested:
                return "interested"
            }
        }
    }
    
    var seller: PFUser? {
        get {
            return parseObject[Field.Seller.key] as? PFUser
        }
        set {
            parseObject[Field.Seller.key] = newValue ?? NSNull()
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
            parseObject[Field.Longitude.key] = newValue
        }
    }
    
    var sold: Bool? {
        get {
            return parseObject[Field.Sold.key] as? Bool
        }
        set {
            parseObject[Field.Sold.key] = newValue
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
    
    var city: String? {
        get {
            return parseObject[Field.City.key] as? String
        }
        set {
            parseObject[Field.City.key] = newValue
        }
    }
    
    
    var id: String? {
        get {
            return parseObject[Field.ID.key] as? String
        }
    }
    
    var interested: [String]? {
        get {
            return parseObject[Field.Interested.key] as? [String]
        }
        set {
            if newValue != nil {
                parseObject[Field.Interested.key] = newValue
            } else {
                parseObject[Field.Interested.key] = NSNull()
                
            }
        }
    }

    
//    private (set)
    var parseObject: PFObject
    
    init(_ parseObject: PFObject? = nil) {
        self.parseObject = parseObject ?? PFObject(className: "Post")
    }


    class func createPost(images: [UIImage], name: String, seller: PFUser, itemDescription: String, price: Double, conditionNew: Bool, negotiable: Bool, sold: Bool, city: String, latitude: Double, longitude: Double) -> Post {
        
//        let newPost = Post()
//        newPost.name = "Alvin"
//        let postKey = Post.Field.Name.key
        
        let newPost = Post()
        
        newPost.seller = seller
        
        newPost.name = name
        
        newPost.itemDescription = itemDescription
        
        newPost.price = price
        
        newPost.conditionNew = conditionNew
        
        newPost.negotiable = negotiable
        
        newPost.sold = sold
        
        newPost.latitude = latitude
        
        newPost.city = city
        
        newPost.longitude = longitude
        
        newPost.interested = nil
        
        
        
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
        
        
    
        return newPost // should this return the parse object or the Post object? I think the Post object...
        
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
    
    class func getRelativeDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Configure output format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        var createdAtString = ""
        
        let interval = -1 * Int(date.timeIntervalSinceNow)
        if interval < 60 {
            let intervalString = String(interval)
            createdAtString = intervalString + "s"
            
        } else if interval < 3600 {
            let intervalString = String(interval / 60)
            createdAtString = intervalString + "m"
            
        } else if interval < 86400 {
            let intervalString = String(interval / 60 / 60)
            createdAtString = intervalString + "h"
            
        } else if interval < 604800 {
            let intervalString = String( interval / 60 / 60 / 24)
            createdAtString = intervalString + "d"
            
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            // Convert Date to String
            createdAtString = formatter.string(from: date)
        }

        return createdAtString
    }
    
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}
