//
//  SelectVideoCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 11/12/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import AVKit

class SelectVideoCell: UICollectionViewCell {
    
    
    let videoView: AVPlayer = {
        let video = AVPlayer()
        return video
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(videoView)
//        videoView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
