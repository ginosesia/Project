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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Basket"
        
        tableView.separatorColor = .clear
        
        tableView.register(BasketCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        CheckOutButton()
        
        fetchItemsInBasket()
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
        navigationItem.rightBarButtonItems = [pay]
    }
    
    @objc func handleCheckOut() {
        print("checkout")
    }
    
    //MARK: - Footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        setUpFooter(footerView: footerView)
        return footerView
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
            view.backgroundColor = .white
            return view
        }()
        
        let total: UILabel = {
            let label = UILabel()
            label.text = "Total:  £ \(totalPrice)"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()
        
        let numberOfProducts: UILabel = {
            let label = UILabel()
            label.text = "Items: \(totalNumber)"
            label.font = UIFont.boldSystemFont(ofSize: 18)
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
