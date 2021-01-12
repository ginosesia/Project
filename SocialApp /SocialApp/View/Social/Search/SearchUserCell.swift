//
//  SearchContentVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 04/06/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class SearchUserCell: UITableViewCell {
    
    
    //MARK: - Properties
    
    var delegate: SearchCellDelegate?
    
    var user: User? {
        didSet {
            configureFollowButton()
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImage.loadImage(with: profileImageUrl)
            
        }
    }
    
    
    func configureFollowButton() {
        
        user?.checkIfUserIsFollowed(completion: { (followed) in
            if self.user?.uid == Auth.auth().currentUser?.uid {
                self.followButton.isHidden = true
            }
            if followed {
                Utilities.styleFollowButton(self.followButton, following: true)
            } else {
                Utilities.styleFollowButton(self.followButton, following:false)
            }
        })
    }
    
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Handlers
    
    @objc func handleFollowTapped() {
        if user!.isFollowed {
            user!.unfollow()
            print("Unfollowed User")
            Utilities.styleFollowButton(followButton, following: false)
        } else {
            user!.follow()
            print("Followed User")
            Utilities.styleFollowButton(followButton, following: true)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.layer.cornerRadius = 55*0.33
        addSubview(followButton)
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 90, height: 30)
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        followButton.layer.cornerRadius = 10
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.textColor = .white
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y-2, width: 300, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        textLabel?.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: followButton.leftAnchor, paddingTop: 22, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        detailTextLabel?.textColor = .white
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y, width: 300, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.anchor(top: textLabel?.bottomAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, right: followButton.leftAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        let name = user!.firstname + " " + user!.lastname
        self.textLabel?.text = name
        self.detailTextLabel?.text = user?.username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
