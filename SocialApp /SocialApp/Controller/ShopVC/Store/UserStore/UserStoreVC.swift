//
//  UserStoreVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 11/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "StoreHeader"

class UserStoreVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserStoreHeaderDelegate, SettingsLauncherDelegate {
    
    var delegate: ItemConfirmationDelegate?
    var store: Store?
    let settingsLauncher = StoreSettingsLauncher()
    let cellId = "cellId"
    var user: User?
    var items = [Item]()
    var customView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let ordersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        customView.isHidden = true
        view.backgroundColor = .black
        fetchItems()
        setupNavBar()
        
        settingsLauncher.delegate = self
            
        collectionView.register(UINib(nibName: headerIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(StoreHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(MyShopItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func setupNavBar() {
        let more = UIImage(systemName: "line.horizontal.3")
        let orders = UIImage(systemName: "bell")
        
        let moreButton = UIBarButtonItem(image: more, style: .plain, target: self, action: #selector(handleMoreTappeed))
        let orderButton = UIBarButtonItem(image: orders, style: .plain, target: self, action: #selector(handleOrdersTapped))
        navigationItem.rightBarButtonItems = [moreButton,orderButton]
    }
    
    
    @objc func handleMoreTappeed() {
        settingsLauncher.showSettings()
    }
    
    @objc func handleOrdersTapped() {
        let orders = MyOrders()
        self.navigationController?.pushViewController(orders, animated: true)
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
    
    func sendConfirmationAlert(item: Item) {
        
        // create the alert
        guard let item = item.itemTitle else { return }
        let alert = UIAlertController(title: "Item Added to Basket", message: "\(item) has been added to your basket successfully.", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue Shopping", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "View Basket", style: UIAlertAction.Style.default, handler: {_ in
            let checkOut = Basket()
            self.navigationController?.pushViewController(checkOut, animated: true)
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
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
        let width = (collectionView.frame.width)
        return CGSize(width: width, height: width/3)
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func settingDidSelected(setting: Setting) {
        if setting.name == "Add Item" {
            addItem()
        } else if setting.name == "Analytics" {
            print("Analytics")
        } else if setting.name == "Settings" {
            print("Settings")
        } else if setting.name == "Cancel" {
        }
    }
    
    //MARK: - API
    

    func fetchItems() {
        guard let id = store?.uid else { return }
        USER_ITEMS_REF.child(id).observe(.childAdded) { (snapshot) in
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
