//
//  ProfileHeader.swift
//  SocialApp
//
//  Created by Gino Sesia on 29/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class ProfileHeader: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            configureEditProfileFollowButton()
            
            //set users stats
            setUserStats(for: user)
            let fName = user?.firstname
            
            let lName = user?.lastname
            
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
    
    lazy var messageUserButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.addTarget(self, action: #selector(messageUser), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight(rawValue: 30))
        return label
    }()
    
    let profileDescription: UILabel = {
        let label = UILabel()
        label.text = "Content Creator and Business owner"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let ocupation: UILabel = {
        let label = UILabel()
        label.textColor = Utilities.setThemeColor()
        label.text = "Video Creator"
        label.font = UIFont.systemFont(ofSize: 13)
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
    
    lazy var myShopButton: UIButton = {
        let button = UIButton(type: .system)
        Utilities.styleStoreButton(button)
        button.addTarget(self, action: #selector(handleStoreButtonTapped), for: .touchUpInside)
        return button
    }()
  
    lazy var videoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Videos", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var pictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pictures", for: .normal)
        button.tintColor = Utilities.setThemeColor()
        button.layer.backgroundColor = UIColor(red:15/255, green: 15/255, blue: 15/255, alpha: 1).cgColor
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(pictureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Posts", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let stack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var menuBar: MenuBar = {
        let bar = MenuBar()
        return bar
    }()
   
    let collectionView: CollectionView = {
        let cv = CollectionView()
        return cv
    }()
    
    //MARK: - Handlers
    
    @objc func videoButtonTapped() {
        Utilities.buttonPressed(videoButton, pictureButton, postButton)
    }
    
    @objc func pictureButtonTapped() {
        Utilities.buttonPressed(pictureButton, videoButton, postButton)
    }
    
    @objc func postButtonTapped() {
        Utilities.buttonPressed(postButton, videoButton, pictureButton)
    }
    
    @objc func handleMore() {
        delegate?.handleMoreTapped(for: self)
    }
    
    @objc func messageUser() {
        delegate?.handleMessageUserTapped(for: self)
    }
    
    @objc func handleFollowingTaped() {
        delegate?.handleFollowingTapped(for: self)
    }
    
    @objc func handleUploadsTaped() {
        delegate?.handleUploadsTaped(for: self)
    }
    
    @objc func handleFollowersTaped() {
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleEditProfileFollowButton() {
        delegate?.handleEditFollowTapped(for: self)
    }
    
    @objc func handleStoreButtonTapped() {
        delegate?.handleStoreTapped(for: self)
    }
    
    @objc func handleBannerTapped() {
        delegate?.handleEditBannerTapped(for: self)
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
        
        backgroundColor = .black
        //Layout of profile
        configureProfileLayout()
        
    }    
    
    
    func configureProfileLayout() {
        let height = CGFloat(120)

        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: height, height: height)
        profileImage.layer.cornerRadius = height/2
        //center image
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nil, left: nil, bottom: profileImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -10, paddingRight: 0, width: 100, height: 30)
        editProfileFollowButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        
        addSubview(name)
        name.anchor(top: profileImage.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        addSubview(ocupation)
        ocupation.anchor(top: name.bottomAnchor, left: name.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(profileDescription)
        profileDescription.anchor(top: ocupation.bottomAnchor, left: ocupation.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: editProfileFollowButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 70, paddingBottom: 0, paddingRight: 70, width: 100, height: 80)
        stackView.layer.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30, alpha: 1).cgColor
        stackView.layer.cornerRadius = 15

        addSubview(menuBar)
        menuBar.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 40)

        addSubview(collectionView)
        collectionView.anchor(top: menuBar.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}