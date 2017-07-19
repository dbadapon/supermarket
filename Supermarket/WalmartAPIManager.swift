//
//  WalmartAPIManager.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/18/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import Alamofire

class WalmartAPIManager {
    
    class func checkPriceWithName(query: String) -> Double {
        var price = -100.0
        let baseURL = "http://api.walmartlabs.com/v1/search?query="
        let endUrl = "&format=json&apiKey=yva6f6yprac42rsp44tjvxjg"
        
        let newString = query.replacingOccurrences(of: " ", with: "+")
        var wholeUrl = baseURL + newString + endUrl
        
        request(wholeUrl, method: .get).validate().responseJSON { (response) in
            if response.result.isSuccess,
                let responseDictionary = response.result.value as? [String: Any] {
                let numberOfItems = responseDictionary["numItems"] as! Int
                if numberOfItems > 0 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let items = itemArray[0] as! [String: Any]
                    
                    price = items["salesPrice"] as! Double
                }
            } else {
                print ("it's not getting a response")
                print (response.result.error)
            }
            
        }
        return price
        
    }
    
    class func getNameWithId(query: String) -> String {
        var name = ""
        
        let baseURL = "http://api.walmartlabs.com/v1/search?query="
        let endUrl = "&format=json&apiKey=yva6f6yprac42rsp44tjvxjg"
        
        let newString = query.replacingOccurrences(of: " ", with: "+")
        var wholeUrl = baseURL + newString + endUrl
        
        request(wholeUrl, method: .get).validate().responseJSON { (response) in
            if response.result.isSuccess,
                let responseDictionary = response.result.value as? [String: Any] {
                let numberOfItems = responseDictionary["numItems"] as! Int
                if numberOfItems > 0 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let items = itemArray[0] as! [String: Any]
                    
                    name = String(describing: items["name"]!)
                }
            } else {
                print ("it's not getting a response")
                print (response.result.error)
            }
            
        }
        return name
    }
    
}