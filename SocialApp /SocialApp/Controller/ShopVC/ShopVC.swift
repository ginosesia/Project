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

class ShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ShopVCDelegate  {
    
 
    
    //MARK: - Properties
    var items = [Item]()

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView.register(ShopCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationController?.navigationBar.isHidden = true
    
        fetchItems()

    }

    //MARK: - CollectionView
    
        
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-5, height: view.frame.width/1.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopCell
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        cell.layer.cornerRadius = 10
        cell.item = items[indexPath.item]
        return cell
    }


    //MARK: - Handlers
    
    func handlePurchaceTapped(for cell: ShopCell) {
        print("working")
    }

    //MARK: - API
    
    func fetchItems() {
        ITEMS_REF.observe(.childAdded) { (snapshot) in
            let itemId = snapshot.key
            ITEMS_REF.child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let item = Item(itemId: itemId, dictionary: dictionary)
                self.items.append(item)
                self.collectionView.reloadData()
            })
        }
    }
    
}
