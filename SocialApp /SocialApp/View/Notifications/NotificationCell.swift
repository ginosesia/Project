//
//  NotificationCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 20/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit


class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemTeal
        return image
    }()

    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "Gino", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 12)),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedText.append(NSAttributedString(string: " commented on your post", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        attributedText.append(NSAttributedString(string: "\n2 Days Ago", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        label.attributedText = attributedText
        return label
    }()

    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        Utilities.styleFollowButton(button, following: true)
        button.addTarget(self, action: #selector(handleFollowButton), for: .touchUpInside)
        return button
    }()

    let postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemTeal
        return image
    }()
    
    func setUpView() {
        let imageDimention = CGFloat(45)
        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: imageDimention, height: imageDimention)
        profileImage.layer.cornerRadius = imageDimention/2
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(followButton)
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 28)
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(notificationLabel)
        notificationLabel.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        notificationLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        addSubview(postImage)
        postImage.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 50)
        postImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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
