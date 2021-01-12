//
//  FacebookSignInVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 30/06/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit


class FacebookSignInVC: UIViewController {

    let returnToSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Return to Sign in?", for: .normal)
        button.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()
               
    @objc func handleShowSignIn() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    let signUp: UILabel = {
        let logo = UILabel()
        logo.text = "FACEBOOK"
        logo.textColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        logo.textAlignment = .center
        logo.font = UIFont.boldSystemFont(ofSize: 15)
        return logo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUp)
        signUp.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        view.addSubview(returnToSignInButton)
        returnToSignInButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 0, width: 0, height: 50)
    }
    
    
    
    
    


}
