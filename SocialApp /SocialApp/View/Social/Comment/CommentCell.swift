//
//  CommentCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 02/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import ActiveLabel


class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var comment: Comment? {
        didSet {
            guard let user = comment?.user else { return }
            guard let profileImageUrl = user.profileImageUrl else { return }
            
            //Add users Profile Image using profile Url frome database
            profileImage.loadImage(with: profileImageUrl)

            configureCommentLabel()
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let commentLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = Utilities.setThemeColor()
        return label
    }()

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        profileImage.layer.cornerRadius = 45*0.33
        
        addSubview(commentLabel)
        commentLabel.anchor(top: nil, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        commentLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true

    }
    
    //MARK: - Handlers
    
    func configureCommentLabel() {
        
        guard let user = comment?.user else { return }
        guard let username = user.username else { return }
        guard let commentText = comment?.commentText else { return }
        //guard let commemt = self.comment else { return }

        
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        commentLabel.enabledTypes = [.hashtag,.mention,.url]

        
        commentLabel.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            
            switch type {
            case .custom:
                atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 15)
            default:
                ()
            }
            return atts
        }
        commentLabel.customize { (label) in
            label.text = username + " \(commentText)"
            label.customColor[customType] = .white
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .white
            label.numberOfLines = 0
            
        }
    }
    
    func configureNotificationTimeStamp() -> String? {
        
        guard let comment = self.comment else { return nil }
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second,.month,.hour,.day,.weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: comment.creationDate, to: now)
        
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
