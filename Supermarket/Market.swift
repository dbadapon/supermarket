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
    
    class func postMarket(withName name: String, withCategories categories: [Category]?, withNewCategory newCategory: Bool, withPublic isPublic: Bool,  withCompletion completion: PFBooleanResultBlock?) {
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
}
