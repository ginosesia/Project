//
//  MessagesCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 13/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    
    
    
    //MARK: - Properties
    var message: Message? {
        didSet {
            
            guard let messageText = message?.messageText else { return }
            detailTextLabel?.text = messageText
            
            if let seconds = message?.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: seconds)
            }
            
            configureUserData()
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 7
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .black
        
        //Set Layout
        configureLayout()
        
        layoutSubviews()
        
    }
        
    //MARK: - Layout
       
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.textColor = .white
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y-2, width: 300, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        detailTextLabel?.textColor = .gray
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y, width: 300, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        
    }
    
    
    func configureLayout() {
        
        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        profileImage.layer.cornerRadius = 45 * 0.33
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        timeLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers
    
    func configureUserData() {
        
        guard let chatPartner = message?.getChatPartnerId() else { return }
        
        Database.fetchUser(with: chatPartner) { (user) in
            self.profileImage.loadImage(with: user.profileImageUrl)
            self.textLabel?.text = user.username
        }
    }
    
}
