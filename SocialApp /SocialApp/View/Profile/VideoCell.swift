//
//  VideoCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 24/11/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//


import UIKit

class VideoCell: UICollectionViewCell {
    

    let videoThumbnail: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 7
        return image
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Video Title"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(videoThumbnail)
        videoThumbnail.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
        addSubview(title)
        title.anchor(top: topAnchor, left: videoThumbnail.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        title.centerYAnchor.constraint(equalTo: videoThumbnail.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
