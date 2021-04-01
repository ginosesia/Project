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

    var store: Store? {
        didSet {
            guard let imageUrl = store?.storeImageUrl else { return }
            storeImage.loadImage(with: imageUrl)
        }
    }
    
    var item: Item? {
        didSet {
            guard let productName = item?.itemTitle else { return }
            productTitle.text = productName

            guard let image = item?.imageUrl else { return }
            productImage.loadImage(with: image)
            
            guard let price = item?.itemPrice else { return }
            productPrice.text = "£\(price)"
            
            guard let uid = item?.uid else { return }
            if uid == Auth.auth().currentUser?.uid {
                info.isEnabled = false
            }

        }
    }
    
    let productTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.tintColor = UIColor.white
        return label
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
    
    let storeImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()


    lazy var info: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Utilities.setThemeColor()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = UIColor.white
        button.setTitle("Add To Basket", for: .normal)
        button.layer.cornerRadius = 5
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
    
    func getStore() {
        STORE_REF.observe(.childAdded) { (snapshot) in
            let storeId = snapshot.key
            guard let uid = self.item?.uid else { return }
            STORE_REF.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let store = Store(uid: storeId, dictionary: dictionary)
                self.store = store
            })
        }
    }

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        moreInfo.delegate = self
        
        setUpStore()
        getStore()
    }
    
    //MARK: - Views
    
    func setUpStore() {
        addSubview(productTitle)
        addSubview(storeImage)

        productTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: storeImage.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 20)
        
        let size = CGFloat(25)
        storeImage.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: size, height: size)
        storeImage.centerYAnchor.constraint(equalTo: productTitle.centerYAnchor).isActive = true
        storeImage.layer.cornerRadius = size/2
        addSubview(productPrice)
        productPrice.anchor(top: productTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 2.5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
        
        addSubview(productImage)
        productImage.anchor(top: productPrice.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        productImage.layer.cornerRadius = 5
        
        addSubview(info)
        info.anchor(top: productImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 7, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 35)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
