//
//  File.swift
//  SocialApp
//
//  Created by Gino Sesia on 24/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class JoinShopVC: UIViewController {
    
    var user: User?
    
    let joinShop: UIButton = {
        let button = UIButton()
        button.backgroundColor = Utilities.setThemeColor()
        button.setTitle("Join Now", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
        
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsersData()

        view.backgroundColor = .black
        navigationItem.title = "Join Shop Now"
        navigationController?.navigationBar.tintColor = .black
  
        view.addSubview(joinShop)
        joinShop.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 40, paddingRight: 30, width: 0, height: 45)

    }
    
    //MARK: - Handlers
    @objc func handleButtonTapped() {
        let test = MyStoreSignUpVC()
        test.user = user
        navigationController?.pushViewController(test, animated: true)
    }
    
    func fetchUsersData() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("Users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: userDictionary)
            self.user = user
        })
    }
}
