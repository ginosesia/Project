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
            guard let creationDate = post?.creationDate else { return }

            postImage.loadImage(with: postImageUrl)
            caption.text = postCaption
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
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
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
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
