//
//  NotificationsVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ShopCell"

class ShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
 
    
    //MARK: - Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(ShopCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationController?.navigationBar.isHidden = true
        
        fetchItems()
    
    }
    
    
    func collectionView(_ collectionView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Line 64: ShopVC")
    }
    
    
    //MARK: - API
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-5, height: view.frame.width/1.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        cell.layer.cornerRadius = 10
        return cell
        
    }
    

    //MARK: - Handlers
    
    func fetchItems() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
    
        USER_STORE_REF.child(uid).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
        
        }

    }
    
}
