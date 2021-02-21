//
//  NotificationsCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 09/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class ShopCell: UICollectionViewCell, ShopSettingsLauncherDelegate {
    

    
    //MARK: - Properties
    let moreInfo = ItemMoreOptions()
    var member = true
    var delegate: ItemConfirmationDelegate?

    var item: Item? {
        didSet {
            guard let productName = item?.itemTitle else { return }
            productTitle.setTitle(productName, for: .normal)

            guard let image = item?.imageUrl else { return }
            productImage.loadImage(with: image)
            
            guard let price = item?.itemPrice else { return }
            productPrice.text = "£\(price)"
         }
    }
    
    let productTitle: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    let productPrice: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.tintColor = .white
        return lb
    }()
    
    let productImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    lazy var info: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Utilities.setThemeColor()
        button.setTitle("Add To Basket", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handlePurchaceTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - Handlers
    
    @objc func handlePurchaceTapped(for cell: ShopCell) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["title": item!.itemTitle!,
                      "price": item!.itemPrice!,
                      "imageUrl": item!.imageUrl!] as [String: Any]

        USER_BAG_REF.child(uid).child((item?.itemId)!).setValue(values)
        sendConfirmationAlert()
    }
    
    func sendConfirmationAlert() {
        delegate?.sendConfirmationAlert(item: item!)
    }

    
    func settingDidSelected(setting: Setting) {
        
    }

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        moreInfo.delegate = self
        
        setUpStore()
    }
    
    //MARK: - Views
    
    func setUpStore() {
        addSubview(productTitle)
        productTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        addSubview(productPrice)
        productPrice.anchor(top: productTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 2.5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
        
        addSubview(productImage)
        productImage.anchor(top: productPrice.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        productImage.layer.cornerRadius = 10
        
        addSubview(info)
        info.anchor(top: productImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 35)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
