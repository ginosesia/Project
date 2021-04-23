//
//  ProfileHeader.swift
//  SocialApp
//
//  Created by Gino Sesia on 29/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class ProfileHeader: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    
    var delegate: UserProfileHeaderDelegate?
    var items = [Item]()
    var user: User? {
        didSet {
            configureEditProfileFollowButton()
            
            //set users stats
            setUserStats(for: user)
            let fName = user?.firstname
            let lName = user?.lastname
            let bio = user?.bio
            let desc = user?.description
            
            let fullName = (fName ?? "") + " " + (lName ?? "")
            name.text = fullName
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImage.loadImage(with: profileImageUrl)
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor.black
        return image
    }()
        
    let name: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight(rawValue: 30))
        label.numberOfLines = 0
        return label
    }()

    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 27)),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        label.attributedText = attributedText
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 27)),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        label.attributedText = attributedText
        
        //Add gesture recogniser
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTaped))
        followingTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followingTap)
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 27)),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        label.attributedText = attributedText
        
        //Add gesture recogniser
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTaped))
        followersTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followersTap)
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleEditProfileFollowButton), for: .touchUpInside)
        return button
    }()
    
    let stack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

        
    //MARK: - Handlers

    
    @objc func handleFollowingTaped() {
        delegate?.handleFollowingTapped(for: self)
    }
    
    @objc func handleFollowersTaped() {
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleEditProfileFollowButton() {
        delegate?.handleEditFollowTapped(for: self)
    }
        
    func configureUserInfo() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 0, height: 50)
    }
    
    func setUserStats(for user: User?) {
        delegate?.setUserStats(for: self)
    }
    
    
    func configureEditProfileFollowButton() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        if currentUid == user.uid {
            Utilities.styleEditProfileButton(self.editProfileFollowButton)
        } else {
            editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
            user.checkIfUserIsFollowed(completion: { (followed) in
                
                if followed {
                    Utilities.styleFollowButton(self.editProfileFollowButton, following: true)
                } else {
                    Utilities.styleFollowButton(self.editProfileFollowButton, following: false)
                }
            })
        }
    }
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        fetchItems()
        backgroundColor = .black
        //Layout of profile
        configureProfileLayout()
    }    
    
    
    func configureProfileLayout() {
        let height = CGFloat(115)

        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: height, height: height)
        profileImage.layer.cornerRadius = height/2
        //center image
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nil, left: nil, bottom: profileImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -10, paddingRight: 0, width: 90, height: 30)
        editProfileFollowButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        
        addSubview(name)
        name.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        name.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: editProfileFollowButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 60, paddingBottom: 0, paddingRight: 60, width: frame.width/1.1, height: 80)
        stackView.layer.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30, alpha: 1).cgColor
        stackView.layer.cornerRadius = 15
        

    }
        
    func fetchItems() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        USER_ITEMS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let itemId = snapshot.key
            ITEMS_REF.child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let item = Item(itemId: itemId, dictionary: dictionary)
                self.items.append(item)
            })
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
