//
//  ItemMoreOptions.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private var reuseidentifier = "cellId"

class ItemMoreOptions: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ShopSettingsLauncherDelegate?

    
    let blackView = UIView()
    let cellHeight = CGFloat(50)
    let headerId = "headerId"
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 35, green: 35, blue: 35, alpha: 1)
        return cv
    }()
    
    let itemId = "o8765rdc876rfghj765r5678ijh"
    let itemTitle = "Test title6"
    
    let settings: [Setting] = {
       return [
            Setting(name: "test", imageName: "photo"),
            Setting(name: "Add To Basket", imageName: "cart.badge.plus"),
            Setting(name: "Share", imageName: "square.and.arrow.up"),
            Setting(name: "Cancel", imageName: "xmark")
       ]
    }()
    
    override init() {
        super.init()
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: reuseidentifier)
        self.collectionView.register(StoreSettingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }

    func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor.clear
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            let height: CGFloat = 700
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            collectionView.layer.cornerRadius = 15
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)

            } completion: { (nil) in
                
            }
        }
    }
    
    @objc func handleDismiss() {
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow {
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
            } completion: { (nil) in
                
        }
    }

    
    @objc func handleDismissAndPresenetController(setting: Setting) {
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow {
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
            } completion: { (nil) in
                self.delegate?.settingDidSelected(setting: setting)
                if (setting.name == "Add To Basket") {
                    self.addToBasket()
                } else if (setting.name == "test") {
                    print("test")
                } else if (setting.name == "Share") {
                    self.share()
                } else if (setting.name == "Cancel") {
                    print("cancel")
                }
        }
    }
    
    func addToBasket() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        USER_BAG_REF.child(uid).child(itemId).setValue(itemTitle)
    }

    func share() {
        
    }

    //MARK: - Header
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = collectionView.frame.width/2
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        
        return header
    }

    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath) as! SettingsCell
        
        let setting = settings[indexPath.row]
        cell.setting = setting
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: cellHeight)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.settings[indexPath.item]
        handleDismissAndPresenetController(setting: setting)
    }
}
