//
//  StoreHeader.swift
//  SocialApp
//
//  Created by Gino Sesia on 26/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class StoreHeader: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    var store: Store? {
        didSet {
            guard let image = store?.storeImageUrl else { return }
            profileImage.loadImage(with: image)
        }
    }
    
    var delegate: UserStoreHeaderDelegate?
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
                

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Layout of profile
        configureStoreLayout()
                
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureStoreLayout() {
        let height = CGFloat(125)

        addSubview(profileImage)
        profileImage.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: height, height: height)
        profileImage.layer.cornerRadius = height/2
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

    }
    
}
