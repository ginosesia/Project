//
//  File.swift
//  SocialApp
//
//  Created by Gino Sesia on 24/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class JoinShopVC: UIViewController {
    
    
    let joinShop: UIButton = {
        let button = UIButton()
        button.backgroundColor = Utilities.setThemeColor()
        button.setTitle("Become a member", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
        
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        
        view.addSubview(joinShop)
        joinShop.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 100, paddingRight: 20, width: 0, height: 45)
        
  
    }
    
    //MARK: - Handlers
    @objc func handleButtonTapped() {
        
        print("JoinShopVC: Line 44")
        
    }
}
