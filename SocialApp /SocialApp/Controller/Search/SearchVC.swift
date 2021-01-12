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

class SearchVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: Properties
    var users = [User]()
    var searchBar = UISearchBar()
    var filteredUsers = [User]()
    var isSearchMode = false
    var collectionView: UICollectionView!
    var collectionViewEnebled = true
    var posts = [Post]()
    var key: String?
    var userKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //register cell
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        configureSearchBar()
        
        //separator insets
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        view.backgroundColor = .black
        tableView.separatorColor = .clear
        navigationController?.navigationBar.isHidden = false
        
        configureCollectionView()
        
        fetchPosts()
        
        //refresh
        configureHandleRefresh()
        
       
    }
    //MARK: - Handlers
    
    @objc func handleRefresh() {
        users.removeAll(keepingCapacity: false)
        self.key = nil
        fetchUsers()
        collectionView?.reloadData()
    }
    
    func configureHandleRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if users.count > 21 {
            if indexPath.item == users.count - 1 {
                fetchUsers()
            }
        }
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var user: User!
        if isSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        //creates instance of userProfile
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        //passes user from searchVC to profilVC
        userProfileVC.user = user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        var user: User!
        if isSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.user = user
        return cell
    }
    //MARK: - UICollection View
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if posts.count > 9 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }
    
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)! - 45)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(SearchPostCell.self, forCellWithReuseIdentifier: "SearchPostCell")
        
        collectionView.backgroundColor = .white
        
        tableView.addSubview(collectionView)
        tableView.separatorColor = .clear
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        feedVC.viewFromProfile = true
        feedVC.post = posts[indexPath.item]
        navigationController?.pushViewController(feedVC, animated: true)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchPostCell", for: indexPath) as! SearchPostCell
        
        cell.post = posts[indexPath.row]
        
        return cell
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
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        fetchUsers()
        collectionView.isHidden = true
        collectionViewEnebled = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //search text did change
        let searchTextLowercase = searchText.lowercased()
        let searchTextCapital = searchText
        if searchTextLowercase.isEmpty || searchTextLowercase == " " || searchTextCapital.isEmpty || searchTextCapital == " " {
            isSearchMode = false
            tableView.reloadData()
        } else {
            isSearchMode = true
            filteredUsers = users.filter({ (user) -> Bool in
                return user.firstname.contains(searchTextCapital) || user.username.contains(searchTextLowercase) || user.lastname.contains(searchTextCapital)
                
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        isSearchMode = false
        searchBar.text = nil
        
        collectionViewEnebled = true
        collectionView.isHidden = false
        
        tableView.reloadData()
        
    }
    
    //MARK: - API
    func fetchUsers() {
        
        if userKey == nil {
            
            USER_REF.queryLimited(toLast: 20).observeSingleEvent(of: .value) { (snapshot) in
                
                self.collectionView.refreshControl?.endRefreshing()

                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let uid = snapshot.key
                    self.fetchUser(with: uid)
                })
                self.userKey = first.key
            }
            
        } else {
            
            USER_REF.queryOrderedByKey().queryEnding(atValue: userKey).queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in

                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }

                allObjects.forEach({ (snapshot) in
                    let uid = snapshot.key
                    self.fetchUser(with: uid)
                })
                self.userKey = first.key
            })
        }
    }
    
    
    
    func fetchUser(with uid: String) {
        Database.fetchUser(with: uid, completion: { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        })
    }
    
    
    
    func fetchPosts() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if key == nil {
            POSTS_REF.child(currentUid).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in

                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    self.fetchPost(with: postId)
                })
                self.key = first.key
            })
        } else {
            POSTS_REF.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.key).queryLimited(toLast: 11).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.key {
                        self.fetchPost(with: postId)
                    }
                })
                self.key = first.key
            })
        }
    }
    
    
    func fetchPost(with postId: String) {
        
        Database.fetchPost(with: postId, completion: { (post) in
            self.posts.append(post)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView.reloadData()
        })
    }
    
}
