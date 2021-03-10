//
//  PendingOrders.swift
//  SocialApp
//
//  Created by Gino Sesia on 05/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class PendingOrders: UITableViewController {

    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPendingItems()

        tableView.register(PendingCell.self, forCellReuseIdentifier: reuseIdentifier)

        navigationItem.title = "My Orders"

    }

    //MARK: - Header

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        headerView.backgroundColor = .black
        setUpHeader(headerView: headerView)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

        
    //MARK: - Table View

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PendingCell
        cell.item = items[indexPath.item]
        return cell
    }

    
    func setUpHeader(headerView: UIView) {
        
        
        let item: UILabel = {
            let label = UILabel()
            label.text = "Item"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()
        
        let Delivery: UILabel = {
            let label = UILabel()
            label.text = "Delivery"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()

        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray2
            return view
        }()

        headerView.addSubview(item)
        item.anchor(top: nil, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        item.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        headerView.addSubview(Delivery)
        Delivery.anchor(top: nil, left: nil, bottom: nil, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        Delivery.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        headerView.addSubview(separator)
        separator.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.8)
    }

    
    func fetchPendingItems() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        MY_ORDERS_REF.child(uid).observe(.childAdded) { (snapshot) in
            let itemId = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let item = Item(itemId: itemId, dictionary: dictionary)
            self.items.append(item)
            self.tableView.reloadData()
        }
    }

    
    // MARK: Footer View

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .black

        setUpFooter(footerView: footerView)
        return footerView
    }

    func setUpFooter(footerView: UIView) {
                
        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray2
            return view
        }()
                
        let numberOfProducts: UILabel = {
            let label = UILabel()
            label.text = "Items: \(items.count)"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()
        
        footerView.addSubview(separator)
        separator.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: footerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.8)
        footerView.addSubview(numberOfProducts)
        numberOfProducts.anchor(top: nil, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        numberOfProducts.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true

    }
    

    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
