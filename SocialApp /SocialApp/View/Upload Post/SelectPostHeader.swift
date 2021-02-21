//
//  SelectPostHeader.swift
//  SocialApp
//
//  Created by Gino Sesia on 06/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class SelectPostHeader: UICollectionViewCell {
  
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
                           
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.width)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
