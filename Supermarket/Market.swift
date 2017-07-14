//
//  Market.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import Parse

class Market: NSObject {
    
    class func postMarket(withName name: String, withCategories categories: [String: [Post]?]?, withNewCategory newCategory: Bool, withPublic isPublic: Bool,  withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        
        let market = PFObject(className: "Market")
        
        market["name"] = name
        market["admin"] = PFUser.current()
        var members: [PFUser] = []
        members.append(PFUser.current()!)
        market["members"] = members
        if categories == nil {
            market["categories"] = NSNull()
        } else {
            market["categories"] = categories
        }
        
        market["memberCanCreateNewCategory"] = newCategory
        market["public"] = isPublic
        
        
        // Save object (following function will save the object in Parse asynchronously)
        market.saveInBackground(block: completion)
    }
    
    class func postToMarkets(destinations: [String: [String]], post: Post) {
        var query = PFQuery(className: "Market")
        
        query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                print (markets!.count)
                var count = 1
                for market in markets! {
                    print (String(count))
                    count = count + 1
                    if destinations.keys.contains(market["name"] as! String) { // only go through markets in destinations
                        
                        let categoryDestinations = destinations[market["name"] as! String]
                        
                        var categories = market["categories"] as! [String: [Post]?]

                        
                        for category in categoryDestinations! {
                            var posts = categories[category] as? [Post]
                            if posts == nil {
                                posts = []
                                posts?.append(post)
                            } else {
                                posts!.append(post)
                            }
                            categories[category] = posts
                        }
                        market["categories"] = categories
                        market.saveInBackground(block: { (saveSuccess, saveError: Error?) in
                            if let saveError = saveError {
                                print (saveError.localizedDescription)
                            } else {
                                print ("")
                            }
                        })
                        
                    } else {
                        // If this market is NOT one of the destinations, nothing should happen
                    }
                }
            }
        }
    }
}
