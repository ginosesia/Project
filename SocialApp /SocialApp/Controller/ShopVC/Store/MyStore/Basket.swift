//
//  CheckoutViewController.swift
//  SocialApp
//
//  Created by Gino Sesia on 19/02/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "BasketCell"


class Basket: UITableViewController {
    
    var items = [Item]()
    var hasItems = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Basket"
        
        tableView.separatorColor = .clear
        
        tableView.register(BasketCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        CheckOutButton()
        
        fetchItemsInBasket()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BasketCell
        cell.item = items[indexPath.item]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, commit trailingSwipeActionsConfigurationForRowAt: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let itemId = items[indexPath.item].itemId else { return }
        USER_BAG_REF.child(uid).child(itemId).removeValue()
        tableView.deleteRows(at: [indexPath], with: .fade)
        items.remove(at: indexPath.item)
    }

    func fetchItemsInBasket() {
        ITEMS_REF.observe(.childAdded) { (snapshot) in
            let itemId = snapshot.key
            guard let uid = Auth.auth().currentUser?.uid else { return }
            USER_BAG_REF.child(uid).child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let item = Item(itemId: itemId, dictionary: dictionary)
                self.items.append(item)
                self.tableView.reloadData()
            })
        }
    }
    
    func CheckOutButton() {
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()
        let pay = UIBarButtonItem(title: "Check Out", style: .plain, target: self, action: #selector(handleCheckOut))
        //if items.count != 0 {
            navigationItem.rightBarButtonItems = [pay]
        //}
    }

    
    @objc func handleCheckOut() {
        
        if items.count != 0 {
            checkIfInStock(items: items)
        } else {
            let alert = UIAlertController(title: "Empty Basket", message: "You have no items in your basket", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkIfInStock(items: [Item]) {
        for item in items {
            guard let itemId = item.itemId else { return }
            ITEMS_REF.child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                guard let stock = dictionary["quantity"] as? Int else { return }
                if stock < 1 {
                    guard let title = item.itemTitle else { return }
                    let alert = UIAlertController(title: "Out Of Stock", message: "\(title) is out of stock.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Return to Basket", style: .cancel, handler: { (_) in
                        _ = self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            })
        }
        let form = CheckOutFormVC()
        form.items = items
        self.navigationController?.pushViewController(form, animated: true)
    }
    
    
    //MARK: - Footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .black
        setUpFooter(footerView: footerView)
        return footerView
    }
    
    
    func setUpHeader(headerView: UIView) {
        
        let price: UILabel = {
            let label = UILabel()
            label.text = "Price"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()
        
        let item: UILabel = {
            let label = UILabel()
            label.text = "Item"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()

        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray2
            return view
        }()
        
        let quantity: UILabel = {
            let label = UILabel()
            label.text = "Quantity"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()

        headerView.addSubview(price)
        price.anchor(top: nil, left: nil, bottom: nil, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        price.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerView.addSubview(quantity)
        quantity.anchor(top: nil, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        quantity.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerView.addSubview(item)
        item.anchor(top: nil, left: quantity.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        item.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        headerView.addSubview(separator)
        separator.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.8)
    }
    
    func setUpFooter(footerView: UIView) {
        
        var totalPrice = CGFloat(0)
        var totalNumber = 0
        
        for item in items {
            let myNumber = NumberFormatter().number(from: item.itemPrice)!
            totalPrice += CGFloat(truncating: myNumber)
            totalNumber += 1
        }
        
        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray2
            return view
        }()
        
        let total: UILabel = {
            let label = UILabel()
            label.text = "Total:  £ \(totalPrice)"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()
        
        let numberOfProducts: UILabel = {
            let label = UILabel()
            label.text = "Items: \(totalNumber)"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()
        
        footerView.addSubview(separator)
        separator.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: footerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.8)
        footerView.addSubview(total)
        footerView.addSubview(numberOfProducts)
        numberOfProducts.anchor(top: nil, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        numberOfProducts.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        total.anchor(top: nil, left: nil, bottom: nil, right: footerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        total.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    }
}
