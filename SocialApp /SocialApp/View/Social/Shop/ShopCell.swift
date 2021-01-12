//
//  NotificationsCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 09/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class ShopCell: UICollectionViewCell {
    
    //MARK: - Properties
    var member = true
    
     
     var item: Item? {
         didSet {
             
            
            guard let productName = item?.itemTitle else { return }
            productTitle.setTitle(productName, for: .normal)
            
            guard let itemPrice = item?.itemPrice else { return }
            let price = String(itemPrice)
            productPrice.setTitle(price, for: .normal)

            
            guard let image = item?.imageUrl else { return }
            productImage.loadImage(with: image)
            
         }
     }
     

    
    //MARK: - Handlers
    
    let productTitle: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("PRODUCT TITLE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    let productPrice: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitle("PRICE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    let productImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = Utilities.setThemeColor().cgColor
        return image
    }()
    
    lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info"), for: .normal)
        button.tintColor = Utilities.setThemeColor()
        return button
    }()

    lazy var purchaseItem: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Utilities.setThemeColor()
        button.setTitle("Purchase", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if member {
            setUpStore()
        } else {
            setUpBecomeAMember()
        }
        
    }
    
    //MARK: - Views
    
    func setUpStore() {
        
        addSubview(productTitle)
        productTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        
        addSubview(infoButton)
        infoButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        infoButton.centerYAnchor.constraint(equalTo: productTitle.centerYAnchor).isActive = true
        
        addSubview(productPrice)
        productPrice.anchor(top: productTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 2.5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)

        
        addSubview(productImage)
        productImage.anchor(top: productPrice.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        productImage.layer.cornerRadius = 10
        
        addSubview(purchaseItem)
        purchaseItem.anchor(top: productImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 35)
        
    }
    
    func setUpBecomeAMember() {
        
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
