//
//  Relation.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/24/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import UIKit
import Parse


class MarketPost {
    
    
    enum Field {
        case Post, Price, Market, Category
        
        var key: String {
            switch (self) {
            case .Post:
                return "post"
            case .Price:
                return "price"
            case .Market:
                return "market"
            case .Category:
                return "category"
            }
        }
    }
    
    // be careful with ! as opposed to ?, apparently...
    var post: String? {
        get {
            return parseObject[Field.Post.key] as? String
        }
        set {
            parseObject[Field.Post.key] = newValue
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
    
    var market: String? {
        get {
            return parseObject[Field.Market.key] as? String
        }
        set {
            parseObject[Field.Market.key]  = newValue
        }
    }
    
    var category: String? {
        get {
            return parseObject[Field.Category.key] as? String
        }
        set {
            parseObject[Field.Category.key] = newValue
        }
    }
    
    
    var parseObject: PFObject
    
    init(_ parseObject: PFObject? = nil) {
        self.parseObject = parseObject ?? PFObject(className: "MarketPost")
    }
    
    class func postItem(post: Post, marketName: String, category: String) {
        
        
        let marketPost = MarketPost()
        
        marketPost.post = post.id
        marketPost.price = post.price
        marketPost.market = marketName
        marketPost.category = category
        
        marketPost.parseObject.saveInBackground { (success, error) in
            if let error = error {
                print("Error creating MarketPost: \(error.localizedDescription)")
            } else {
                print("MarketPost should have saved!")
            }
        }
    }
    
}
