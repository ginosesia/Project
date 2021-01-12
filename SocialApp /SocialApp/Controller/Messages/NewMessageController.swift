//
//  NewMessageController.swift
//  SocialApp
//
//  Created by Gino Sesia on 14/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase


private let reuseIdentifier = "NewMessageCell"

class NewMessageController: UITableViewController, UISearchBarDelegate {
    
    
    //MARK: - Properties
    var searchBar = UISearchBar()
    var isSearchMode = false
    var filteredUsers = [User]()
    var users = [User]()
    var messageController: MessagesController?
    
   
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nav bar
        configureNavBar()
        //register cell
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = .black
        tableView.separatorColor = .clear
        
        fetchUsers()
        

    }
    
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
        cell.backgroundColor = .black
        cell.user = users[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messageController?.showChatController(forUser: user)
        }
    }

    //MARK: - Handlers
    
    func configureNavBar() {
        navigationItem.title = "New Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchForUser))
    }
    
    @objc func handleMessage() {
        dismiss(animated: true)
    }
    
    //MARK: - Search Bar
    @objc func searchForUser() {
        configureSearchBar()
    }
    
    @objc func cancelSearchForUser() {
        configureNavBar()
        searchBar.isHidden = true
        
    }
    
    @objc func cancelSearch() {
        print("dismiss")
    }
    
    func configureSearchBar() {
        
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.tintColor = UIColor(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
        view.backgroundColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch))

        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //search text did change
        let searchText = searchText.lowercased()
        if searchText.isEmpty || searchText == " " {
            isSearchMode = false
            tableView.reloadData()
        } else {
            isSearchMode = true
            filteredUsers = users.filter({ (user) -> Bool in
                return user.username.contains(searchText)
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        isSearchMode = false
        searchBar.text = nil
        
        tableView.isHidden = false
        
        tableView.reloadData()
        
    }
    
    //MARK: - API
    
    func fetchUsers() {
        
        USER_REF.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            if uid != Auth.auth().currentUser?.uid {
                
                
                Database.fetchUser(with: uid) { (user) in
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            } else {
            }
        }
    }
}
