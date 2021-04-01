//
//  BasketCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class BasketViewCell: UICollectionViewCell {
    
    var item: Item? {
        didSet {
            guard let itemTitle = item?.itemTitle else { return }
            guard let itemPrice = item?.itemPrice else { return }
            guard let itemUrl = item?.imageUrl else { return }

            image.loadImage(with: itemUrl)
            itemsTitle.text = itemTitle
            itemsPrice.text = "£ \(itemPrice)"
        }
    }
    
    let image: CustomImageView = {
        let im = CustomImageView()
        return im
    }()
    
    let itemsTitle: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return lb
    }()
    
    let itemsPrice: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(image)
        image.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.height, height: 0)
        
        addSubview(itemsTitle)
        itemsTitle.anchor(top: topAnchor, left: image.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        addSubview(itemsPrice)
        itemsPrice.anchor(top: itemsTitle.bottomAnchor, left: image.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        backgroundColor = .systemGray6
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
