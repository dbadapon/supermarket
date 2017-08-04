//
//  GoogleBooksAPI.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import Alamofire

class GoogleBooksAPI {
    
    class func searchGoogleBooksWithIsbn(isbn: String) -> [String: Any]? {
        var returnedDictionary: [String: Any]? = [:]
        print ("it's checking google books")
        let baseUrl = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
        let endUrl = "&key=AIzaSyDVlUc9ewaWiblEpv5J6jgexZ_DUoPMUIs"
        let wholeUrl = baseUrl + isbn + endUrl
        
        request(wholeUrl, method: .get).validate().responseJSON { (response) in
            if response.result.isSuccess,
                let responseDictionary = response.result.value as? [String: Any] {
                print ("THIS IS THE RESPONSEDICTIONA \(responseDictionary)")
                let totalItems = responseDictionary["totalItems"] as! Int
                if totalItems > 0 {
                    let items = responseDictionary["items"] as! [[String: Any]]
                    let item = items[0]
                    var sortedDictionary: [String: Any] = [:]
                    
                    let volumeInfo = item["volumeInfo"] as! [String: Any]
                    sortedDictionary["title"] = volumeInfo["title"]
                    let authors = volumeInfo["authors"] as? [String]
                    if let authors = authors {
                        sortedDictionary["authors"] = authors
                    }
                    
                    sortedDictionary["pageCount"] = volumeInfo["pageCount"]
                    let imageLinks = volumeInfo["imageLinks"] as? [String: Any]
                    if let imageLinks = imageLinks {
                        sortedDictionary["image"] = imageLinks["thumbnail"]
                    }
                    
                    let saleInfo = item["saleInfo"] as? [String: Any]
                    if let saleInfo = saleInfo {
                        let listPrice = saleInfo["listPrice"] as? [String: Any]
                        if let listPrice = listPrice {
                            sortedDictionary["price"] = listPrice["amount"]
                        }
                    }
                    returnedDictionary = sortedDictionary
                }
            } else {
                print("Error in searchGoogleBooksWithIsbn")
                // print(response.result.error?.localizedDescription)
            }
        }
        return returnedDictionary
    }
    
}
