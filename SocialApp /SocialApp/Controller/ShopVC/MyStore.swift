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

class MyStore: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserStoreHeaderDelegate, SettingsLauncherDelegate,ItemOptionsDelegate {

    

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
        fetchStoreData()
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
    
    func handleOptionsTapped(item: Item) {

        let menuWidth = view.frame.width
        view.addSubview(customView)
        customView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: menuWidth/1.3, height: menuWidth)
        customView.layer.cornerRadius = 15
        customView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        customView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customView.isHidden = false
        customView.backgroundColor = .systemGray5

        setUpMenu(item: item)
    }
  
    func setUpMenu(item: Item) {
        
        let cancel: UIButton = {
            let bt = UIButton(type: .system)
            bt.setTitle("Cancel", for: .normal)
            bt.tintColor = .systemBlue
            bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bt.addTarget(self, action: #selector(handleCancelTapped), for: .touchUpInside)
            return bt
        }()
        
        let delete: UIButton = {
            let bt = UIButton(type: .system)
            bt.setTitle("Delete", for: .normal)
            bt.addTarget(self, action: #selector(handleDeleteTapped), for: .touchUpInside)
            bt.tintColor = .red
            bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            return bt
        }()

        let horzStack = UIStackView(arrangedSubviews: [cancel, delete])
        horzStack.axis = .horizontal
        horzStack.distribution = .fillEqually
        

        customView.addSubview(horzStack)
        horzStack.anchor(top: nil, left: customView.leftAnchor, bottom: customView.bottomAnchor, right: customView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 8, paddingRight: 30, width: 0, height: 0)
        
        titleLabel.text = item.itemTitle
        stockLabel.text = "Stock: \(item.itemStock ?? "0")"
        priceLabel.text = "Price: £\(item.itemPrice ?? "0")"
        ordersLabel.text = "Orders: 2"

        customView.addSubview(titleLabel)
        titleLabel.anchor(top: customView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        
        customView.addSubview(priceLabel)
        priceLabel.anchor(top: titleLabel.bottomAnchor, left: customView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        customView.addSubview(stockLabel)
        stockLabel.anchor(top: priceLabel.bottomAnchor, left: customView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        customView.addSubview(ordersLabel)
        ordersLabel.anchor(top: stockLabel.bottomAnchor, left: customView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func handleCancelTapped() {
        customView.isHidden = true
        titleLabel.text = ""
    }
    
    @objc func handleDeleteTapped() {
        titleLabel.text = ""
        print("delete")
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
        cell.delegate = self
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editItem = EditStoreItem()
        editItem.item = items[indexPath.item]
        self.navigationController?.pushViewController(editItem, animated: true)
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
