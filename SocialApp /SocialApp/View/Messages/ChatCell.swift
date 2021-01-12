//
//  ChatCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 14/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatCell: UICollectionViewCell {
    
    //MARK: - Properties
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var timeRightAnchor: NSLayoutConstraint?
    var timeLeftAnchor: NSLayoutConstraint?

    var delegate: ChatCellSettingsDelegate?
    
    var message: Message? {
        didSet {
            
            guard let messageTest = message?.messageText else { return }
            textView.text = messageTest
            guard let chatPartnerId = message?.getChatPartnerId() else { return }
            
            Database.fetchUser(with: chatPartnerId) { (user) in
                guard let profileImageUrl = user.profileImageUrl else { return }
                self.profileImageView.loadImage(with: profileImageUrl)
            }
        }
    }

    
    let bubbleView: UIView = {
        let bubble = UIView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.layer.masksToBounds = true
        bubble.layer.cornerRadius = 13
        return bubble
    }()
    
    let textView: UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.font = UIFont.systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isEditable = false
        text.backgroundColor = .clear
        return text
    }()
    
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
  
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 8)
        label.backgroundColor = .black
        return label
    }()
    
    
    //MARK: - Handlers
    
    
    @objc func handleOptionsTapped() {
        print("options")
    }
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(timeStamp)
        
        if profileImageView.image == nil {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
            profileImageView.tintColor = .white
        }
        
        
        profileImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
        profileImageView.layer.cornerRadius = 18*0.33
        profileImageView.centerYAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true

        //right anchor
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        bubbleRightAnchor?.isActive = true
        
        //left anchor
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15)
        bubbleLeftAnchor?.isActive = true
        
        //bubble view width and top anchor
        bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 260)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //bubble textView
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 2.5).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor,constant: -5).isActive = true
        textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant:  -5).isActive = true
        textView.layer.cornerRadius = 25/2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
