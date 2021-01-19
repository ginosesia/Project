//
//  Store.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Firebase

class Store {
    
    var storeName: String!
    var email: String!
    var storeImageUrl: String!
    var uid: String!
    
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let storeName = dictionary["storeName"]as? String {
            self.storeName = storeName
        }
        
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        
        if let storeImageUrl = dictionary["storeImageUrl"] as? String {
            self.storeImageUrl = storeImageUrl
        }

        
    }
}

