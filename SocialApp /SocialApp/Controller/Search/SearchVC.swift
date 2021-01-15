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
    var users = [User]()
    var filteredUsers = [User]()
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
        configureSearchBar()

        view.backgroundColor = .black
        //separator insets
        tableView.separatorColor = UIColor.rgb(red: 30, green: 30, blue: 30, alpha: 1)
        navigationController?.navigationBar.isHidden = false
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        var user: User!
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user: User!

        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        let searchTextuppercased = searchText
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filteredUsers = users.filter({ (user) -> Bool in
                return user.username.contains(searchText) || user.firstname.contains(searchTextuppercased) || user.lastname.contains(searchTextuppercased)
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        inSearchMode = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUsers() {
        
        Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let user = User(uid: uid, dictionary: dictionary)
            self.users.append(user)
            self.tableView.reloadData()
            
        }
        
    }
    
}
