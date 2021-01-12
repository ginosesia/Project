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
    var ownerUid: String!
    var itemId: String!
    var itemTitle: String!
    var creationDate: Date!
    var itemPrice: Double!
    var user: User?

    
    init(itemId: String!, user: User, dictionary: Dictionary<String, AnyObject>) {
        
        
        self.user = user
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let itemPrice = dictionary["itemPrice"] as? Double {
            self.itemPrice = itemPrice
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let itemTite = dictionary["itemTitle"] as? String {
            self.itemTitle = itemTite
        }
        
        if let itemId = dictionary["itemId"] as? String {
            self.itemId = itemId
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }

    

}
