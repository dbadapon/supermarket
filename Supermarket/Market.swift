//
//  Market.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import Parse

class Market{
    
    enum Field {
        case Name, Description, Admin, Members, MemberCount, Categories, City, ProfileImage, Latitude, Longitude
        
        var key: String {
            switch (self) {
            case .Name:
                return "name"
            case .Description:
                return "description"
            case .Admin:
                return "admin"
            case .Members:
                return "members"
            case .MemberCount:
                return "memberCount"
            case .Categories:
                return "categories"
            case .City:
                return "city"
            case .Latitude:
                return "latitude"
            case .Longitude:
                return "longitude"
            case .ProfileImage:
                return "profileImage"
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
    
    var description: String? {
        get {
            return parseObject[Field.Description.key] as? String
        }
        set {
            parseObject[Field.Description.key] = newValue
        }
    }
    
    var members: [PFUser]? {
        get {
            return parseObject[Field.Members.key] as? [PFUser]
        }
        set {
            parseObject[Field.Members.key] = newValue
        }
    }
    
    var memberCount: Int64? {
        get {
            return parseObject[Field.MemberCount.key] as? Int64
        }
        set {
            parseObject[Field.MemberCount.key] = newValue
        }
    }
    
    var categories: [String] {
        get {
            return parseObject[Field.Categories.key] as! [String]
        }
        set {
            parseObject[Field.Categories.key] = newValue
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
    
    
    var latitude: Double? { // so why do all of these things have to be optional?
        get {
            return parseObject[Field.Latitude.key] as? Double
        }
        set {
            parseObject[Field.Latitude.key] = newValue
        }
    }
    
    var longitude: Double? { // so why do all of these things have to be optional?
        get {
            return parseObject[Field.Longitude.key] as? Double
        }
        set {
            parseObject[Field.Longitude.key] = newValue
        }
    }
    
    var profileImage: PFFile? {
        get {
            return parseObject[Field.ProfileImage.key] as? PFFile
        }
        set {
            parseObject[Field.ProfileImage.key] = newValue
        }
    }
    

    var parseObject: PFObject
    
    init(_ parseObject: PFObject? = nil) {
        self.parseObject = parseObject ?? PFObject(className: "Market")
    }

    
    class func createMarket(profileImage: UIImage, withName name: String, withDescription description: String, withCategories categories: [String], withLatitude latitude: Double?, withLongitude longitude: Double?, withCompletion completion: PFBooleanResultBlock?) {
        
        let newMarket = Market()
        newMarket.name = name
        newMarket.categories = categories
        newMarket.latitude = latitude
        newMarket.longitude = longitude
        newMarket.description = description
        newMarket.profileImage = getPFFileFromImage(image: profileImage)
        
        
        
        newMarket.parseObject.saveInBackground { (success, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
            } else if success {
                print ("success in saving the market")
            } else {
                print ("there was no error, but the market was not successful saving")
            }
        }
    
    }
    
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
    
/*
    class func postToMarkets(destinations: [String: String], post: Post) {
        let postObject = post.parseObject
//        let query = PFQuery(className: "Market")
//        for (market, category) in destinations {
//            let query = PFQuery(className: "Market")
//            query.whereKey("name", equalTo: market)
//            query.findObjectsInBackground(block: { (markets, error) in
//                if let markets = markets {
//                    markets
//                }
//            })
//        }
        let query = PFQuery(className: "Market")
        query.findObjectsInBackground { (markets, error) in
            if let markets = markets {
                for m in markets {
                    let market = Market(m)
                    if let category = destinations[market.name!] {
                        var categoryArray = market.categories[category] as? [PFObject]
                        categoryArray!.append(postObject)
                        market.categories[category] = categoryArray
                        
                        market.parseObject.saveInBackground(block: { (success, error) in
                            if success {
                                print("Posted to \(category)!")
                            } else {
                                print("Error saving post to market: \(error?.localizedDescription)")
                            }
                        })
                    }
                }
            }
            else {
                print("Error posting to market: \(error?.localizedDescription)")
            }
        }
    }
    
    func postToMarket(category: String, postObject: Post) {
        let post = postObject.parseObject
        var marketCategories = self.categories
        var posts = marketCategories[category]!
        if posts != nil {
            var newPosts = posts!
            newPosts.append(post)
            marketCategories[category] = newPosts
        } else {
            var newPosts: [PFObject]? = []
            newPosts!.append(post)
            marketCategories[category] = newPosts
        }
        self.categories = marketCategories

        }
     
    */
    
    func save() {
        self.parseObject.saveInBackground { (success, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
            } else if success {
                print ("success saving changes to market")
            } else {
                print ("the market changes were not saved successfully, but there was no error.")
            }
        }
    }
        
    
}
