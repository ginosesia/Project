//
//  StoreHeader.swift
//  SocialApp
//
//  Created by Gino Sesia on 26/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class StoreHeader: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    var store: Store? {
        didSet {
            
            guard let name = store?.storeName else { return }
            guard let image = store?.storeImageUrl else { return }
            
            profileImage.loadImage(with: image)
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor.systemPink
        return image
    }()
    
    lazy var addItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAddItemTapped), for: .touchUpInside)
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = Utilities.setThemeColor()
        button.backgroundColor = .white
        return button
    }()
    
    let itemsLabel: UILabel = {
        let label = UILabel()
        label.text = "Items"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let numberofItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "21"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    //MARK: - Handlers
    
    @objc func handleAddItemTapped() {
        print("handle add item")
    }
    

    //MARK: - Init
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Layout of profile
        configureProfileLayout()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureProfileLayout() {
        let height = CGFloat(100)

        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: height, height: height)
        profileImage.layer.cornerRadius = height/2
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(addItemButton)
        addItemButton.anchor(top: profileImage.topAnchor, left: nil, bottom: nil, right: profileImage.rightAnchor, paddingTop: -3, paddingLeft: 0, paddingBottom: 0, paddingRight: -3, width: 30, height: 30)
        addItemButton.layer.cornerRadius = 15
        
        let stackView = UIStackView(arrangedSubviews: [numberofItemsLabel,itemsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        stackView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true

        
    
    }
    
}
