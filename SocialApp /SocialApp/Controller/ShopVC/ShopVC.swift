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

class ShopVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ShopVCDelegate, ItemConfirmationDelegate  {

    //MARK: - Properties
    var items = [Item]()
    var basket = [Item]()

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(ShopCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationController?.navigationBar.isHidden = true
    
        fetchItems()
        fetchItemsInBasket()
    }

    //MARK: - CollectionView
    
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moreInfo = ProductInfoVC()
        moreInfo.item = items[indexPath.item]
        //let navController = UINavigationController(rootViewController: moreInfo)
        navigationController?.present(moreInfo, animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
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
        cell.item = items[indexPath.item]
        return cell
    }

    //MARK: - Handlers
    
    func handlePurchaceTapped(for cell: ShopCell) {
        print("working")
    }
    
    func sendConfirmationAlert(item: Item) {
        
        var quantity = basket.count
        
        quantity += 1
        
        // create the alert
        guard let item = item.itemTitle else { return }
        let alert = UIAlertController(title: "Item Added to Basket", message: "\(item) has been added to your basket successfully.", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue Shopping", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "View Basket (\(quantity))", style: UIAlertAction.Style.default, handler: {_ in
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
