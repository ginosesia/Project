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
            guard let imageUrl = post?.imageUrl else { return }
            postImage.loadImage(with: imageUrl)
        }
    }
    
    let postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 7
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(postImage)
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
