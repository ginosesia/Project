//
//  Extensions.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

extension Date {
    
    func timePosted() -> String {
        
        let time = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        
        if time < minute {
            quotient = time
            unit = "second"
        } else if time < hour {
            quotient = time/minute
            unit = "min"
        } else if time < day {
            quotient = time/hour
            unit = "hour"
        } else if time < week * 2 {
            quotient = time/week
            unit = "day"
        } else if time < month {
            quotient = time/month
            unit = "week"
        } else {
            quotient = time/month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s" ) ago"
    }
    
    
}



extension UIColor {
    
    static func rgb(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
}


extension UIViewController {
    
    func uploadNotification(for postId: String, with text: String, isForComment: Bool) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        
        var type: Int!
        if isForComment {
            type = COMMENT_INT_VALUE
        } else {
            type = POST_MENTION_INT_VALUE
        }
        
        for var word in words {
            if word.hasPrefix("@") {
                word = word.trimmingCharacters(in: .symbols)
                word = word.trimmingCharacters(in: .punctuationCharacters)
                
                USER_REF.observe(.childAdded, with: { (snapshot) in
                
                    let uid = snapshot.key
                    
                    USER_REF.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                        
                        if word == dictionary["Username"] as? String {
                            let notificationValues = ["postId": postId,
                                                      "uid": uid,
                                                      "type": type ?? 0,
                            "creationDate":creationDate] as [String: Any]
                            
                            if currentUid != uid {
                                NOTIFICATIONS_REF.child(uid).childByAutoId().updateChildValues(notificationValues)
                            }
                        }
                    })
                })
            }
        }
    }

    
    
    func getMention(with username: String) {
        USER_REF.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            
            USER_REF.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }

                if username == dictionary["Username"] as? String {

                    Database.fetchUser(with: userId, completion:  { (user) in

                        let controller = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                        controller.user = user
                        self.navigationController?.pushViewController(controller, animated: true)
                        return
                    })
                }
            })
        }
    }




}



extension UIView {
    
    
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
     
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    
    @discardableResult
       func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
           let gradient: CAGradientLayer = CAGradientLayer()
           gradient.frame = self.bounds
           gradient.colors = colours.map { $0.cgColor }
           gradient.locations = locations
           self.layer.insertSublayer(gradient, at: 0)
           return gradient
       }

    
    func gradientButton( startColor:UIColor, endColor:UIColor) {

            let view:UIView = UIView(frame: self.bounds)

            let gradient = CAGradientLayer()
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.frame = self.bounds
            self.layer.insertSublayer(gradient, at: 0)
            self.mask = view

            view.layer.borderWidth = 20
        
    }
}


extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: Int) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}




extension Database {
    
    
    static func fetchPost(with postId: String, completion: @escaping(Post) -> ()) {
        POSTS_REF.child("image-posts").child(postId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["ownerUid"] as? String else { return }

            Database.fetchUser(with: ownerUid) { (user) in
                let post = Post(postId: postId, user: user, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    
    
    static func fetchUser(with uid: String, completion: @escaping(User) ->()) {
        
        USER_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}


