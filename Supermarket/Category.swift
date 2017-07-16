//
//  Category.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import Parse

class Category: NSObject {
    
    class func postCategory(withName name: String, withPosts posts: [Post]?, withMarket market: Market,  withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        
        let category = PFObject(className: "Category")
        
        category["name"] = name
        category["posts"] = posts
        category["market"] = market
        
        
        // Save object (following function will save the object in Parse asynchronously)
        category.saveInBackground(block: completion)
    }

}
