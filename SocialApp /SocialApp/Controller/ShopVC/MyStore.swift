//
//  MyStore.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "StoreHeader"

class MyStore: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserStoreHeaderDelegate, SettingsLauncherDelegate {

    var store: Store?
    let settingsLauncher = StoreSettingsLauncher()
    let cellId = "cellId"
    var user: User?
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        fetchStoreData()
        fetchItems()
        setupNavBar()
        
        settingsLauncher.delegate = self
            
        collectionView.register(UINib(nibName: headerIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(StoreHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(MyShopItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func setupNavBar() {
        let more = UIImage(systemName: "person.circle")
        let moreButton = UIBarButtonItem(image: more, style: .plain, target: self, action: #selector(handleMoreTappeed))
        navigationItem.rightBarButtonItems = [moreButton]
    }
    
    @objc func handleMoreTappeed() {
        settingsLauncher.showSettings()
    }
    
    //MARK: - Header

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 150)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! StoreHeader
            header.delegate = self
            header.store = store
            
            return header
        }
        else {
            fatalError("Unexpected element kind")
        }
    }
    
    //MARK: - Handlers
    
    func handleAddItemTapped(for header: StoreHeader) {
        addItem()
    }
    
    func addItem() {
        let selectImageVC = UploadItem()
        let navController = UINavigationController(rootViewController: selectImageVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-2)/3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyShopItemCell
        cell.item = items[indexPath.item]
        return cell

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editItem = EditStoreItem()
        editItem.item = items[indexPath.item]
        self.navigationController?.pushViewController(editItem, animated: true)
    }
    
    func settingDidSelected(setting: Setting) {
        if setting.name == "Add Item" {
            addItem()
        } else if setting.name == "Analytics" {
            
        } else if setting.name == "Settings" {
            
        }
    }
    
    //MARK: - API
    
    func fetchStoreData() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        STORE_REF.child(currentUser).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let store = Store(uid: currentUser, dictionary: userDictionary)
            self.store = store
            self.navigationItem.title = store.storeName
            let header = StoreHeader()
            header.profileImage.loadImage(with: store.storeImageUrl)
        }
    }
        
    func fetchItems() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        USER_ITEMS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
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
