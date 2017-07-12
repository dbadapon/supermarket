//
//  User.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class User {
    var name: String
    var email: String
    var sellingItems: [Post]?
    var soldItems: [Post]?
    // var profilePicture:
    var markets: [Market]?
    
    
    
    init() {
        name = "Alvin"
        email = "alvinmagee@something.com"
        
    }
    
    
}
