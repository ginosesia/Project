//
//  SearchVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "SearchUserCell"

class SearchVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    //MARK: Properties
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()

        //separator insets
        view.backgroundColor = .black
        tableView.separatorColor = .clear
        navigationController?.navigationBar.isHidden = false
    }

    //MARK: - Search Bar
    
    func configureSearchBar() {
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
        searchBar.tintColor = Utilities.setThemeColor()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        searchBar.placeholder = "Search User"

    }
    

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //handle
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
}

