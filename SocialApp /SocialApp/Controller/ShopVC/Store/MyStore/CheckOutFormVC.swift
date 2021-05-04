//
//  CheckOutFormVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 09/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CheckOutFormVC: UIViewController {
    
    var items = [Item]()
    var orderId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItemsInBasket()
        collectionView.items = items
        navigationItem.title = "Check Out"
        setUpPage()
        setDate()
    }
    
    func setDate() {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString

        let randomInt = Int.random(in: 0..<9698)
        let orderFormatter : DateFormatter = DateFormatter()
        orderFormatter.dateFormat = "yyyyMMddHHmmss"
        let orderString = orderFormatter.string(from: date)
        orderId = "INV#\(orderString)-\(randomInt)"
        orderNumber.text = orderId
    }
    
    func presentCheckoutForm() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
        for item in items {
            let values = ["title": item.itemTitle!,
                          "price": item.itemPrice!,
                          "imageUrl": item.imageUrl!] as [String: Any]
            MY_ORDERS_REF.child(uid).child((item.itemId)!).setValue(values)
            
        }
    }
    
    func fetchItemsInBasket() {
        ITEMS_REF.observe(.childAdded) { (snapshot) in
            let itemId = snapshot.key
            guard let uid = Auth.auth().currentUser?.uid else { return }
            USER_BAG_REF.child(uid).child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let item = Item(itemId: itemId, dictionary: dictionary)
                self.items.append(item)
            })
        }
    }
    
    func setUpPage() {
        view.backgroundColor = .black
        addViews()
        
        let height = CGFloat(120)
            
        orderNumber.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: height, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dateLabel.anchor(top: orderNumber.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        separator.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        itemsLabel.anchor(top: separator.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.view.anchor(top: itemsLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: view.frame.width, height: view.frame.width)
        deliverLabel.anchor(top: collectionView.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        addressLabel.anchor(top: deliverLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        postcodeLabel.anchor(top: addressLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        checkOut.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 30, paddingRight: 20, width: 0, height: 40)

    }

    func addViews() {
        view.addSubview(orderNumber)
        view.addSubview(dateLabel)
        view.addSubview(separator)
        view.addSubview(itemsLabel)
        view.addSubview(collectionView.view)
        view.addSubview(deliverLabel)
        view.addSubview(addressLabel)
        view.addSubview(postcodeLabel)
        view.addSubview(checkOut)
    }
        
    let orderNumber: UILabel = {
        let lb = UILabel()
        lb.text = "INV#987658714"
        lb.textColor = Utilities.setThemeColor()
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    let dateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray2
        lb.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return lb
    }()
    
    let separator: UIView = {
        let sp = UIView()
        sp.backgroundColor = .systemGray3
        return sp
    }()

    let itemsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.text = "ITEMS"
        lb.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return lb
    }()
    
    let deliverLabel: UILabel = {
        let lb = UILabel()
        let attributedText = NSMutableAttributedString(string: "DELIVER TO ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedText.append(NSAttributedString(string: "\nChange Address in your profile", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 9),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        lb.attributedText = attributedText
        return lb
    }()
    
    let addressLabel: UITextField = {
        let lb = UITextField()
        Utilities.styleTextField(lb, name: "Address")
        lb.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return lb
    }()
    
    let postcodeLabel: UITextField = {
        let lb = UITextField()
        Utilities.styleTextField(lb, name: "Postcode")
        lb.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return lb
    }()

    
    let collectionView: BasketCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = BasketCollectionView(collectionViewLayout: layout)
        return cv
    }()
    
    
    let checkOut: UIButton = {
        let bt = UIButton(type: .system)
        bt.backgroundColor = Utilities.setThemeColor()
        bt.setTitle("CHECKOUT", for: .normal)
        bt.tintColor = .white
        bt.layer.cornerRadius = 7
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        bt.addTarget(self, action: #selector(handleCheckoutTapped), for: .touchUpInside)
        return bt
    }()
    
    //MARK: - Handlers
    
    @objc func handleCheckoutTapped() {

        let alert = UIAlertController(title: "Purchase", message: "Confirm your order", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {_ in
            self.addOrdersToDatabase()
            self.sendItemOwnerNotification()
            self.adjustStock()
            let alert = UIAlertController(title: "Confirmed", message: "Your Order hs been placed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "View Orders", style: UIAlertAction.Style.default, handler: {_ in
                let myOrders = PendingOrders()
                self.navigationController?.pushViewController(myOrders, animated: true)
                self.removeItems()
            }))
            alert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: {_ in
                self.removeItems()
                _ = self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }
    
    func adjustStock() {
        for item in items {
            guard let itemId = item.itemId else {
                return
            }
            ITEMS_REF.child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
                    print("adjusting Stock555")
                    return
                }
                guard let orders = dictionary["orders"] as? Int else {
                    print("adjusting Stock666")
                    return
                }
                guard let stock = dictionary["quantity"] as? String else {
                    print("adjusting Stock777")
                    return
                }
                let totalOrders = orders + 1
                let totalStock = Int(stock)! - 1
                ITEMS_REF.child(item.itemId).child("quantity").setValue(totalStock)
                ITEMS_REF.child(item.itemId).child("orders").setValue(totalOrders)
            })
        }
    }
    
    func removeItems() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        USER_BAG_REF.child(uid).removeValue()
    }
    
    func addOrdersToDatabase() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        for item in items {
            let values = ["title": item.itemTitle!,
                          "price": item.itemPrice!,
                          "imageUrl": item.imageUrl!,
                          "orderId": orderId] as [String: Any]

            MY_ORDERS_REF.child(uid).child(item.itemId).setValue(values)
        }
    }
    
    func sendItemOwnerNotification() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        USER_BAG_REF.child(uid).observe(.childAdded) { (snapshot) in
            let itemId = snapshot.key
            self.getUid(itemId: itemId)
        }
    }
    
    func getUid(itemId: String) {
        ITEMS_REF.observe(.childAdded) { (snapshot) in
            if snapshot.key == itemId {
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let item = Item(itemId: itemId, dictionary: dictionary)
                let userId = item.uid!
                self.sendNotification(userId: userId, itemId: itemId)
            }
        }
    }
    
    func sendNotification(userId: String, itemId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["itemId": itemId,
                      "customerId": uid] as [String: Any]

        NOTIFICATION_ITEMS_REF.child(userId).childByAutoId().setValue(values)
    }
    
}
