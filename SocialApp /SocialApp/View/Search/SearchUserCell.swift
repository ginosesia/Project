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
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImage.loadImage(with: profileImageUrl)
                        
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    //MARK: - Handlers
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = .black
        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.layer.cornerRadius = 25
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.textColor = .white
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y-2, width: 300, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        textLabel?.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 22, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        detailTextLabel?.textColor = .white
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y, width: 300, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.anchor(top: textLabel?.bottomAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        let name = user!.firstname + " " + user!.lastname
        self.textLabel?.text = name
        self.detailTextLabel?.text = user?.username
    
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
