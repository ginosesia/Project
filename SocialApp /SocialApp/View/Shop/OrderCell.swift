//
//  OrderCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 19/02/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class OrderCell: UITableViewCell {
    
    var order: Order? {
        didSet {
            guard let customerId = order?.customerId else { return }
            guard let itemId = order?.itemId else { return }
            
            fetchData(customerId: customerId, itemId: itemId)
        }
    }

    //MARK: - Properties

    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    let postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    
    func setUpView() {
        let imageDimention = CGFloat(45)
        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: imageDimention, height: imageDimention)
        profileImage.layer.cornerRadius = imageDimention/2
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(notificationLabel)
        notificationLabel.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        notificationLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        addSubview(postImage)
        postImage.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 50)
        postImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }
    

    func fetchData(customerId: String, itemId: String) {
        var image1: String?
        var image2: String?
        var name: String?

        USER_REF.child(customerId).observe(.childAdded) { (snapshot) in
            if snapshot.key == "profileImageUrl" {
                image1 = snapshot.value! as? String
                self.profileImage.loadImage(with: image1!)
            }
            
            if snapshot.key == "Username" {
                name = snapshot.value! as? String
                
                let attributedText = NSMutableAttributedString(string: name!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 12)),NSAttributedString.Key.foregroundColor:UIColor.white])
                attributedText.append(NSAttributedString(string: " Purchased your product", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11),NSAttributedString.Key.foregroundColor:UIColor.gray]))
                self.notificationLabel.attributedText = attributedText
                
            }
        }
        
        ITEMS_REF.child(itemId).observe(.childAdded) { (snapshot) in
            if snapshot.key == "imageUrl" {
                image2 = snapshot.value! as? String
                self.postImage.loadImage(with: image2!)
            }
        }
    }
    
    //MARK: - Handlers
    
    @objc func handleFollowButton() {
        print("Handle Follow button tapped")
    }
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        setUpView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
