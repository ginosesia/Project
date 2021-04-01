//
//  DiscoverStoreCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation

import UIKit

class DiscoverStoreCell: UICollectionViewCell {
    
    //MARK: - Properties
        
    var store: Store? {
        didSet {
            
            guard let image = store?.storeImageUrl else { return }
            guard let name = store?.storeName else { return }
            profileImage.loadImage(with: image)
            storeName.text = name
        }
    }
    
    let storeName: UILabel = {
        let lb = UILabel()
        lb.tintColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        return lb
    }()
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
                    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Layout of profile
        configureStoreCellLayout()
    }
    
    func configureStoreCellLayout() {
        
        addSubview(storeName)
        storeName.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        storeName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        addSubview(profileImage)
        let height = CGFloat(100)
        profileImage.anchor(top: storeName.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: height, height: height)
        profileImage.layer.cornerRadius = height/2
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
