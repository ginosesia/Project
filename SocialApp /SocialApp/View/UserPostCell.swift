//
//  UserPostCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 25/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

class UserPostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            guard let postCaption = post?.caption else { return }
            guard let postLikes = post?.likes else { return }
            guard let creationDate = post?.creationDate else { return }


            postImage.loadImage(with: postImageUrl)
            caption.text = postCaption
            likeNumber.text = " \(postLikes) "
            date.text = creationDate.timePosted()

        }
    }
    
    let postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    
    let caption: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
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

    let commentNumber: UILabel = {
        let label = UILabel()
        let commentVC = CommentVC()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = " 0 "
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let likeNumber: UILabel = {
        let label = UILabel()
        label.textColor = Utilities.setThemeColor()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let shareNumber: UILabel = {
        let label = UILabel()
        label.text = " 0 "
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleShareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImage)
        let size = frame.width/3
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 0, width: size, height: size)
        postImage.layer.cornerRadius = 5
        
        addSubview(caption)
        caption.anchor(top: topAnchor, left: postImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        addSubview(date)
        date.anchor(top: caption.bottomAnchor, left: postImage.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.backgroundColor = .systemGray6
        
        configureFunctions()
    }
    
    func configureFunctions() {
        
        let commentInfo = UIStackView(arrangedSubviews: [commentButton,commentNumber])
        commentInfo.axis = .horizontal
        commentInfo.distribution = .fill

        let likeInfo = UIStackView(arrangedSubviews: [likeButton,likeNumber])
        likeInfo.axis = .horizontal
        likeInfo.distribution = .fill
                
        let shareInfo = UIStackView(arrangedSubviews: [shareButton,shareNumber])
        likeInfo.axis = .horizontal
        likeInfo.distribution = .fill

        let functionStackView = UIStackView(arrangedSubviews: [likeInfo,commentInfo, shareInfo])
        functionStackView.axis = .horizontal
        functionStackView.distribution = .equalSpacing
        
        addSubview(functionStackView)
        functionStackView.anchor(top: nil, left: postImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 25, paddingBottom: 15, paddingRight: 25, width: 0, height: 15)
    }
    
    //MARK: - Handlers
    
    @objc func handleLikeButtonTapped() {
    }
    
    @objc func handleCommentButtonTapped() {
    }
    
    @objc func handleShareButtonTapped() {
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
