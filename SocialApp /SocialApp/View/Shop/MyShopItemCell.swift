//
//  MyShopItemCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 26/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class MyShopItemCell: UICollectionViewCell {
    
    var item: Item? {
        didSet {
            guard let image = item?.imageUrl else {
                return
            }
            guard let itemTitle = item?.itemTitle else { return }
            guard let itemPrice = item?.itemPrice else { return }
            guard let itemQuantity = item?.itemQuantity else { return }
            guard let itemOrders = item?.orders else { return }

            title.text = itemTitle
            postImage.loadImage(with: image)
            price.text = "Price: £\(itemPrice)"
            stock.text = "In Stock: \(itemQuantity)"
            orders.text = "Orders: \(itemOrders)"
            print(image)
        }
    }
    
    let postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let stock: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let orders: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImage)
        let size = frame.width/3
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 0, width: size, height: size)
        postImage.layer.cornerRadius = 5
        
        addSubview(title)
        title.anchor(top: postImage.topAnchor, left: postImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        addSubview(price)
        price.anchor(top: title.bottomAnchor, left: postImage.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(stock)
        stock.anchor(top: price.bottomAnchor, left: postImage.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        addSubview(orders)
        orders.anchor(top: stock.bottomAnchor, left: postImage.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.backgroundColor = .systemGray6
        
    }
    
    //MARK: - Handlers

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
