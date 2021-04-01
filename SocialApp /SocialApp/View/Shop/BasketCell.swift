//
//  BasketCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 19/02/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class BasketCell: UITableViewCell {
    
    var item: Item? {
        didSet {
            guard let title = item?.itemTitle else { return }
            guard let price = item?.itemPrice else { return }
            guard let imageUrl = item?.imageUrl else { return }
            
            let myPrice = NumberFormatter().number(from: price)!
            
            productImage.loadImage(with: imageUrl)
            productTitle.text = title
            productPrice.text = "£ \(myPrice)"
        }
    }

    let productTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.tintColor = .white
        return label
    }()

    let productImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let productQuantity: UILabel = {
        let label = UILabel()
        label.text = "1"
        return label
    }()
    
    func setUpView() {
        
        let imageDimention = CGFloat(45)
        addSubview(productPrice)

        addSubview(productQuantity)
        productQuantity.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        productQuantity.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(productImage)
        productImage.anchor(top: nil, left: productQuantity.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 45, paddingBottom: 0, paddingRight: 0, width: imageDimention, height: imageDimention)
        productImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        productImage.layer.cornerRadius = 5

        addSubview(productTitle)
        productTitle.anchor(top: nil, left: productImage.rightAnchor, bottom: nil, right: productPrice.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        productTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        productPrice.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        productPrice.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    
    //MARK: - Handlers
    
    @objc func handleFollowButton() {
        print("Handle Follow button tapped")
    }
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

