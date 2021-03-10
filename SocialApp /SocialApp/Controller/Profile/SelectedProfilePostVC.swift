//
//  SelectedProfilePostVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SelectedProfilePostVC: UIViewController {
    
    var users = [User]()
    

    
    func configureNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(handleDismissTapped))
        navigationItem.title = "Username"
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationButton()
    }
    
    
    func setProfileVariables(indexPath: IndexPath) {
        let user = users[indexPath.row]

        //creates instance of userProfile
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())

        //passes user from searchVC to profilVC
        userProfileVC.user = user

        navigationController?.pushViewController(userProfileVC, animated: true)

    }
    
    
    
    @objc func handleViewProfileTapped() {


    }

    
    @objc func handleDismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    
    
}
