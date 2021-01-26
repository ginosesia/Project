//
//  SettingsCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit


class SettingsCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.rgb(red: 30, green: 30, blue: 30, alpha: 1) : UIColor.rgb(red: 35, green: 35, blue: 35, alpha: 1)
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            
            if let imageName = setting?.imageName {
                icon.image = UIImage(systemName: imageName)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()
    
    let icon: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFill
        im.tintColor =  Utilities.setThemeColor()
        return im
    }()
    
    let badge: UIView = {
        let lb = UIView()
        lb.backgroundColor = .red
        lb.isHidden = true
        return lb
    }()
    
    override func setupViews() {

        addSubview(icon)
        icon.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 25, height: 0)
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(badge)
        badge.anchor(top: topAnchor, left: nil, bottom: nil, right: icon.rightAnchor, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 1, width: 8, height: 8)
        badge.layer.cornerRadius = 4
        
        addSubview(nameLabel)
        nameLabel.anchor(top: nil, left: icon.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    func setupViews() {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
