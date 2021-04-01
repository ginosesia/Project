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
        var width: CGFloat
        
        if stores.count != 0 {
             width = view.frame.width
        } else {
            width = 0
        }
        return CGSize(width: width/2, height: width/1.75)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiscoverStoreCell
        cell.backgroundColor = .systemGray6
        cell.store = stores[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storeVC = MyStore(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(storeVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(DiscoverStoreCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isPagingEnabled = true
        fetchStores()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
