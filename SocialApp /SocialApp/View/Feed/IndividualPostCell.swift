//
//  IndividualPostCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 20/11/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class IndividualPostCell: UICollectionViewCell {
    
    
    
    //MARK: Properties
    
    //var postImage: CustomImageView!
    var delegate: FeedCellDelegate?
    var cellID = "cellId"
    
    var post: Post? {
        didSet {
            guard let ownerUid = post?.ownerUid else { return }
            guard let imageUrl = post?.imageUrl else { return }
            guard let likes = post?.likes else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in
                if user.profileImageUrl == nil {
                    return
                } else {
                    self.profileImage.loadImage(with: user.profileImageUrl)
                }
                self.name.setTitle(user.username, for: .normal)
            }
            postImage.loadImage(with: imageUrl)
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    lazy var name: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 30))
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()

    lazy var postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let postedTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    
    func addSubviews() {
        addSubview(profileImage)
        addSubview(name)
        addSubview(postedTime)
        addSubview(postImage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.purple
        let profileImageHeight = CGFloat(50)
        
        addSubviews()
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: profileImageHeight, height: profileImageHeight)
        profileImage.layer.cornerRadius = profileImageHeight/2
    
        name.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        name.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        postedTime.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        postedTime.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        postImage.anchor(top: profileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 250)
        postImage.layer.cornerRadius = 15
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
