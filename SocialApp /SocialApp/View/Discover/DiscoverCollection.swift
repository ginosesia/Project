//
//  DiscoverCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import Firebase
import UIKit

private let reuseIdentifier = "Cell"


class DiscoverCollection: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties

    var stores = [Store]()
    

    //MARK: - CollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width/2, height: width/1.75)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiscoverStoreCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        cell.layer.cornerRadius = 15
        cell.store = stores[indexPath.item]
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(DiscoverStoreCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isPagingEnabled = true

        fetchStores()

    }
    
    func fetchStores() {
        STORE_REF.observe(.childAdded) { (snapshot) in
            let storeId = snapshot.key
            STORE_REF.child(storeId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let store = Store(uid: storeId, dictionary: dictionary)
                self.stores.append(store)
                self.collectionView.reloadData()
            })
        }

    }
}
