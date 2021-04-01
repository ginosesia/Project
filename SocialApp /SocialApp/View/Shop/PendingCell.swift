//
//  PendingCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 05/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class PendingCell: UITableViewCell {
    
    var item: Item? {
        didSet {
            guard let title = item?.itemTitle else { return }
            guard let imageUrl = item?.imageUrl else { return }
            
            label.text = title
            postImage.loadImage(with: imageUrl)
        }
    }

    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Item 1"
        return label
    }()
    
    let deliveryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Pending"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let postImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(Utilities.setThemeColor(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleOptionsTapped) , for: .touchUpInside)
        return button
    }()
    
    func setUpView() {

        addSubview(optionsButton)
        optionsButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        optionsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(deliveryLabel)
        deliveryLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        deliveryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(postImage)
        postImage.anchor(top: nil, left: optionsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 8, width: 50, height: 50)
        postImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(label)
        label.anchor(top: nil, left: postImage.rightAnchor, bottom: nil, right: deliveryLabel.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }
    
    @objc func handleOptionsTapped() {
        print("Option")
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
