//
//  NewMessageCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 14/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            guard let profileUrl = user?.profileImageUrl else { return }
            guard let username = user?.username else { return }
            guard let name = user?.firstname else { return }
            guard let surname = user?.lastname else { return }
            
            let fullname = "\(name) \(surname)"
            
            profileImage.loadImage(with: profileUrl)
            textLabel?.text = username
            detailTextLabel?.text = fullname
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        //Properties layout
        configureLayout()
        textLabel?.text = "Gino Sesia"
        detailTextLabel?.text = "Test Label"
        
        //LayoutSubviews
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureLayout() {
        
        //Profile Image
        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        profileImage.layer.cornerRadius = 45 * 0.33
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        textLabel?.textColor = .lightGray
        
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y + 2, width: self.frame.width - 108, height: detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
        
    }
    
    
}
