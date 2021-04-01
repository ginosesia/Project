//
//  Order.swift
//  SocialApp
//
//  Created by Gino Sesia on 19/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import Firebase


class Order {
    
    var customerId: String!
    var itemId: String!
    
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        
        if let customerId = dictionary["customerId"]as? String {
            self.customerId = customerId
        }
        
        if let itemId = dictionary["itemId"] as? String {
            self.itemId = itemId
        }
    }
    
}
