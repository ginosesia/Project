//
//  MyStore.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class MyStore: UIViewController {
    
    var store: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        fetchStoreData()
        setupNavBar()
    }
    
    func fetchStoreData() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
    
        STORE_REF.child(currentUser).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let store = Store(uid: currentUser, dictionary: userDictionary)
            self.store = store
            self.navigationItem.title = store.storeName
        }
    }
    
    func setupNavBar() {
        let more = UIImage(systemName: "person.circle")
        let moreButton = UIBarButtonItem(image: more, style: .plain, target: self, action: #selector(handleMoreTapped))

        navigationItem.rightBarButtonItems = [moreButton]
    }
    
    let settingsLauncher = SettingsLauncher()

    @objc func handleMoreTapped() {
        settingsLauncher.showSettings()
    }
    

    
}

