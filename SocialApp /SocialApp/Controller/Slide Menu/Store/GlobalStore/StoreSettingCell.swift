//
//  StoreSettingCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit


class StoreSettingCell: BaseCell {
    
    var item: Item? {
        didSet {
            guard let imageUrl = item?.imageUrl else { return }
            guard let name = item?.itemTitle else { return }
            guard let price = item?.itemPrice else { return }
    
            print(name)
            print("£\(price)")
            print(imageUrl)
        }
    }
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    
    let image: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
        return view
    }()

    override func setupViews() {
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        addSubview(priceLabel)
        priceLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(image)
        let width = self.frame.width/2
        image.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: width)

        addSubview(separator)
        separator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
}
