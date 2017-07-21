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
        case Name, Description, Admin, Members, Categories, Latitude, Longitude
        
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
            case .Categories:
                return "categories"
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
    
    var categories: [String: [PFObject]?] {
        get {
            return parseObject[Field.Categories.key] as! [String: [PFObject]]
        }
        set {
            
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
    
    

    var parseObject: PFObject
    
    init(_ parseObject: PFObject? = nil) {
        self.parseObject = parseObject ?? PFObject(className: "Market")
    }

    
    class func postMarket(withName name: String, withDescription description: String, withCategories categories: [String: [PFObject]?], withNewCategory newCategory: Bool, withPublic isPublic: Bool, withLatitude latitude: Double?, withLongitude longitude: Double?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        
        let newMarket = Market()
        newMarket.name = name
        newMarket.categories = categories
        newMarket.latitude = latitude
        newMarket.longitude = longitude
        newMarket.description = description
        
        newMarket.parseObject.saveInBackground { (success, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
            } else if success {
                print ("success in saving the market")
            } else {
                print ("there was no error, but the market was not successful saving")
            }
        }
        
        
//        let market = PFObject(className: "Market")
//        
//        market["name"] = name
//        market["admin"] = PFUser.current()
//        var members: [PFUser] = []
//        members.append(PFUser.current()!)
//        market["members"] = members
//        if categories == nil {
//            market["categories"] = NSNull()
//        } else {
//            market["categories"] = categories
//        }
//        
//        market["memberCanCreateNewCategory"] = newCategory
//        market["public"] = isPublic
//        
//        if let latitude = latitude {
//            market["latitude"] = latitude
//            market["longitude"] = longitude!
//        }
//        
//        
//        // Save object (following function will save the object in Parse asynchronously)
//        market.saveInBackground(block: completion)
    
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
        
        
        
        
//            var query = PFQuery(className: "Market")
//
//            query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
//                if let error = error {
//                    print (error.localizedDescription)
//                } else {
//                    print (markets!.count)
//                    var count = 1
//                    for market in markets! {
//                        print (String(count))
//                        count = count + 1
//                        if categories.contains(market["name"] as! String) { // only go through markets in destinations
//                            
//                            let categoryDestinations = destinations[market["name"] as! String]
//                            
//                            var categories = market["categories"] as! [String: [PFObject]?]
//                            
//                            for category in categoryDestinations! {
//                                var posts = categories[category] as? [PFObject]
//                                if posts == nil {
//                                    posts = []
//                                    posts?.append(post)
//                                } else {
//                                    posts!.append(post)
//                                }
//                                categories[category] = posts
//                            }
//                            market["categories"] = categories
//                            market.saveInBackground(block: { (saveSuccess, saveError: Error?) in
//                                if let saveError = saveError {
//                                    print ("this is the save error \(saveError.localizedDescription)")
//                                } else {
//                                    print ("")
//                                }
//                            })
//                            
//                        } else {
//                            // If this market is NOT one of the destinations, nothing should happen
//                        }
//                    }
//                }
//            }

        }
    
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
