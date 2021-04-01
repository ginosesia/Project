//
//  UserInfoHeader.swift
//  SettingsTemplate
//
//  Created by Gino Sesia on 05/06/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class UserInfoHeader: UIView {
    
    // MARK: - Properties
    
    var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
        return label
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var line: CustomImageView = {
        let view = CustomImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUserData()

        let profileImageDimension: CGFloat = 90
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = 30
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -11).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 11).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        
        addSubview(line)
        line.layer.borderColor = UIColor.gray.cgColor
        line.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.9)
    }
  
    
    
    func setUserData() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
         
         Database.database().reference().child("Users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let user = User(uid: currentUser, dictionary: userDictionary)

            let titleUsername = user.username
            let userEmail = user.email
            let profilePicture = user.profileImageUrl
            
            self.profileImageView.loadImage(with: profilePicture!)
            self.usernameLabel.text = titleUsername
            self.emailLabel.text = userEmail
            
         })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
