//
//  HashtagCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 29/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HashtagCell: UICollectionViewCell {
    
    //MARK: - Properties
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
        return image
    }()
    
    
    
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImage)
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 2.5, paddingBottom: 0, paddingRight: 2.5, width: 45, height: 45)
        postImage.layer.cornerRadius = 45*0.33

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
