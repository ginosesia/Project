//
//  StoreCreated.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class StoreCreated: UIViewController {

    var name: String?
    var imageUrl: String?
    
    var storeImage: CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
        
    let storeName: UILabel = {
        let name = UILabel()
        name.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        name.font = UIFont.systemFont(ofSize: 30)
        name.textColor = .white
        return name
    }()
    
    let joinShop: UIButton = {
        let button = UIButton()
        button.backgroundColor = Utilities.setThemeColor()
        button.setTitle("View Shop", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        storeName.text = name
        storeImage.loadImage(with: imageUrl!)

        view.addSubview(storeImage)
        storeImage.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 130)
        storeImage.layer.cornerRadius = 65
        storeImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        storeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(storeName)
        storeName.anchor(top: storeImage.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        storeName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(joinShop)
        joinShop.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 40, paddingRight: 30, width: 0, height: 45)

    }
 
    @objc func handleButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }

    
    
}
