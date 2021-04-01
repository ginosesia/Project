//
//  MyOrders.swift
//  SocialApp
//
//  Created by Gino Sesia on 19/02/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "OrderCell"


class MyOrders: UITableViewController {
    
    //MARk: - Properties
    var orders = [Order]()

    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        tableView.register(OrderCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OrderCell
        cell.order = orders[indexPath.item]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
    
    func setNavBar() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()
        navigationItem.title = "Orders"
    }
    

}
