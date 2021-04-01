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
    var items: String!
    var description: String!
    var cardNumber: String!
    var bankName: String!
    var securityCode: String!

    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let cardNumber = dictionary["cardNumber"]as? String {
            self.cardNumber = cardNumber
        }

        if let bankName = dictionary["bankName"]as? String {
            self.bankName = bankName
        }
        
        if let securityCode = dictionary["securityCode"]as? String {
            self.securityCode = securityCode
        }
        
        if let description = dictionary["description"]as? String {
            self.description = description
        }
        
        if let storeName = dictionary["storeName"]as? String {
            self.storeName = storeName
        }

        if let email = dictionary["email"] as? String {
            self.email = email
        }
        
        if let items = dictionary["items"] as? String {
            self.items = items
        }
        
        if let storeImageUrl = dictionary["storeImageUrl"] as? String {
            self.storeImageUrl = storeImageUrl
        }

        
    }
}

