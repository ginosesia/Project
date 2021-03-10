//
//  Item.swift
//  SocialApp
//
//  Created by Gino Sesia on 24/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import Firebase


class Item {
    
    //MARK: - Properties
    
    var imageUrl: String!
    var itemId: String!
    var itemTitle: String!
    var itemDescription: String!
    var creationDate: Date!
    var itemPrice: String!
    var itemStock: String!
    var uid: String!
    var user: User?

    
    init(itemId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let itemPrice = dictionary["price"] as? String {
            self.itemPrice = itemPrice
        }
        
        if let itemTitle = dictionary["title"] as? String {
            self.itemTitle = itemTitle
        }
        
        if let itemStock = dictionary["quantity"] as? String {
            self.itemStock = itemStock
        }
        
        if let itemDescription = dictionary["description"] as? String {
            self.itemDescription = itemDescription
        }
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        }
        
        self.itemId = itemId
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    
}
