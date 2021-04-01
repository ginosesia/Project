//
//  Comment.swift
//  SocialApp
//
//  Created by Gino Sesia on 07/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Comment {
    
    var uid: String!
    var creationDate: Date!
    var commentText: String!
    var user: User?
    
    init(user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.user = user
        
        if let uid = dictionary["uid"] as? String  {
            self.uid = uid
        }
        
        if let commentText = dictionary["commentText"] as? String? {
            self.commentText = commentText
        }
    
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    
    }
    
}
