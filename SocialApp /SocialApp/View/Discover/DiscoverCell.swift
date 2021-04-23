//
//  DiscoverCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 22/04/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class DiscoverCell: UICollectionViewCell {
    
    //MARK: Properties
    
    //var postImage: CustomImageView!
    var delegate: DiscoverCellDelegate?
    var cellID = "cellId"
    
    var post: Post? {
        didSet {
            
            guard let ownerUid = post?.ownerUid else { return }
            guard let imageUrl = post?.imageUrl else { return }
            guard let likes = post?.likes else { return }
            guard let caption = post?.caption else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in
                self.profileImage.loadImage(with: user.profileImageUrl)
                self.name.setTitle(user.username, for: .normal)
                self.configurePostCaption(user: user)
            }
            
            postImage.loadImage(with: imageUrl)
            likeNumber.text = " \(likes) "
            configureLikeButton()
            captionLabel.text = caption
        }
    }

    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
        
    lazy var name: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 30))
        button.addTarget(self, action: #selector(handleUsernameButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    lazy var postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapImage))
        tapGesture.numberOfTouchesRequired = 1
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGesture)
        return image
    }()
    
    let postedTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCommentButtonTapped), for: .touchUpInside)
        return button
     }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleOptionsTapped) , for: .touchUpInside)
        return button
    }()
    
    let likeNumber: UILabel = {
        let label = UILabel()
        label.textColor = Utilities.setThemeColor()
        //add Gesture
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let postTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    //MARK: - Handlers
    

    func configureLikeButton() {
        delegate?.handleConfigureLikeButton(for: self)
    }

    @objc func handleUsernameButtonTapped() {
        delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleLikeButtonTapped() {
        delegate?.handleLikeTapped(for: self, isDoubleTap: false)
    }
    
    @objc func handleCommentButtonTapped() {
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleTapImage() {
        delegate?.handleImageTapped(for: self)
    }
    
    @objc func handleOptionsTapped() {
        delegate?.handleOptionsTapped(for: self)
    }
        
    func configurePostCaption(user: User) {
        guard let caption = self.post?.caption else { return }
        guard let post = self.post else { return }
        guard let username = post.user?.username else { return }
        
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        // enable username as custom type
        captionLabel.enabledTypes = [.mention, .hashtag, .url, customType]
        
        // configure usnerame link attributes
        captionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            
            switch type {
            case .custom:
                atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 13)
            default: ()
            }
            return atts
        }

        captionLabel.customize { (label) in
            label.text = " \(caption)"
            label.customColor[customType] = .white
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .gray
            captionLabel.numberOfLines = 0
        }
        postedTime.text = post.creationDate.timePosted()
    }
    
    func addSubviews() {
        addSubview(profileImage)
        addSubview(name)
        addSubview(postedTime)
        addSubview(postImage)
        addSubview(postTitle)
        addSubview(optionsButton)
        addSubview(captionLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        let profileImageHeight = CGFloat(45)
        
        addSubviews()
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: profileImageHeight, height: profileImageHeight)
        profileImage.layer.cornerRadius = profileImageHeight/2
    
        name.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        name.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        optionsButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        optionsButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        captionLabel.anchor(top: profileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)

        postImage.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: self.frame.width-100)
        postImage.layer.cornerRadius = 15
        
        configureFunctions()
        
    }
    
    
    func configureFunctions() {
        

        let likeInfo = UIStackView(arrangedSubviews: [likeButton,likeNumber])
        likeInfo.axis = .horizontal
        likeInfo.distribution = .fillProportionally
                
        let functionStackView = UIStackView(arrangedSubviews: [likeInfo])
        functionStackView.axis = .horizontal
        functionStackView.distribution = .fillProportionally
        
        addSubview(functionStackView)
        functionStackView.anchor(top: postImage.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 17)
        
        addSubview(postedTime)
        postedTime.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        postedTime.centerYAnchor.constraint(equalTo: functionStackView.centerYAnchor).isActive = true
                
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
