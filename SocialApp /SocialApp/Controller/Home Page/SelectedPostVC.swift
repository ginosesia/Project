//
//  SelectedPostVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class SelectedPostVC: UIViewController {
    
    var users = [User]()
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.backgroundColor = UIColor(displayP3Red: 25/355, green: 25/255, blue: 25/255, alpha: 1).cgColor
        return image
    }()

    let name: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    
    let caption: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Username ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: "test caption", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        label.attributedText = attributedText
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    func configureNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(handleViewProfileTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(handleDismissTapped))
        navigationItem.title = "Username"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        configureNavigationButton()
        
        view.addSubview(name)
        name.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        view.addSubview(profileImage)
        profileImage.anchor(top: name.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 200, height: 200)

    }
    
    @objc func handleViewProfileTapped() {
        print("Display userProfile")
    }

    
    @objc func handleDismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
