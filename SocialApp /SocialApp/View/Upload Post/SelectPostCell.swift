//
//  SelectPostCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 06/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

class SelectPostCell: UICollectionViewCell {
    
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 1, paddingBottom: 0, paddingRight: 1, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
