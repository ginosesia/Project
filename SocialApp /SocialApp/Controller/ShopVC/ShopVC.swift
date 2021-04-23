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

class ShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ShopVCDelegate, ItemConfirmationDelegate  {

    //MARK: - Properties
    var items = [Item]()
    var basket = [Item]()
    var searchBar = UISearchBar()
    var filteredItems = [Item]()
    var inSearchMode = false

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(ShopCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
        fetchItems()
        fetchItemsInBasket()
        
        configureSearchBar()
        
        collectionView.showsVerticalScrollIndicator = false

    }
    
    
    //MARK: - Search bar
    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
        searchBar.tintColor = Utilities.setThemeColor()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        navigationController?.navigationBar.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        let searchTextuppercased = searchText
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
        } else {
            inSearchMode = true
                filteredItems = items.filter({ (item) -> Bool in
                    return item.itemTitle.contains(searchText) || item.itemTitle.elementsEqual(searchText)
                })

            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        inSearchMode = false
        collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - CollectionView
    
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moreInfo = ProductInfoVC()
        if inSearchMode{
            moreInfo.item = filteredItems[indexPath.item]
        } else {
            moreInfo.item = items[indexPath.item]
        }
        navigationController?.present(moreInfo, animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredItems.count
        } else {
            return items.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-5, height: view.frame.width/1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopCell
        cell.delegate = self
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        if inSearchMode{
            cell.item = filteredItems[indexPath.item]
        } else {
            cell.item = items[indexPath.item]
        }
        return cell
    }

    //MARK: - Handlers
    
    func handlePurchaceTapped(for cell: ShopCell) {
        print("working")
    }
    
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
    
    func fetchItemsInBasket() {
        ITEMS_REF.observe(.childAdded) { (snapshot) in
            let itemId = snapshot.key
            guard let uid = Auth.auth().currentUser?.uid else { return }
            USER_BAG_REF.child(uid).child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let item = Item(itemId: itemId, dictionary: dictionary)
                self.basket.append(item)
            })
        }
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
