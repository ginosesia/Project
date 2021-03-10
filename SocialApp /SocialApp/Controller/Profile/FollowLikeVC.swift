//
//  FollowVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 06/06/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//
import UIKit
import Firebase


private let reuseIdentifier = "FollowCell"

class FollowLikeVC: UITableViewController, FollowCellDelegate{
    
    
    //MARK: - Properties

    enum ViewingMode: Int {
        case following
        case followers
        case Likes
         
        init(index: Int) {
            switch index {
                case 0: self = .following
                case 1: self = .followers
                case 2: self = .Likes
                default: self = .followers
            }
        }
    }
    
    var viewingMode: ViewingMode!
    var postID: String?
    var uid: String?
    var users = [User]()
    var followKey: String?
    var likeKey: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FollowLikeCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        //configure navigation controller
            
            //configure nav title
            configureNavTitle()
        
            //fetchusers
            fetchUsers()
        
        
        
        //clear separator lines
        tableView.separatorColor = .clear
        view.backgroundColor = .white
        
        
    }

    //MARK: - Follow Cell Delegate Protocol
 
    func handleFollow(for cell: FollowLikeCell) {
         guard let user = cell.user else { return }
        
        if user.isFollowed {
            user.unfollow()
            print("Unfollowed User")
            Utilities.styleFollowButton(cell.followButton, following: false)

        } else {
            user.follow()
            print("Followed User")
            Utilities.styleFollowButton(cell.followButton, following: true)
        }
    }
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if users.count > 3 {
            if indexPath.item == users.count - 1 {
                fetchUsers()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowLikeCell
        cell.delegate = self
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = user
        navigationController?.pushViewController(userProfileVC, animated: true)
        print("User Selected")
    }
    
    
    func getDatabaceReference() -> DatabaseReference? {
        guard let viewingMode = self.viewingMode else { return nil }
        
        switch viewingMode {
            case .followers: return USER_FOLLOWER_REF
            case .following: return USER_FOLLOWING_REF
            case .Likes: return POST_LIKES_REF
        }
    }
    
    func configureNavTitle() {
        guard let viewingMode = self.viewingMode else { return }

        switch viewingMode {
            case .followers: navigationItem.title = "Followers"
            case .following: navigationItem.title = "Following"
            case .Likes: navigationItem.title = "Likes"
        }
        
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()

    }
    
    func fetchUser(with userID: String) {
        Database.fetchUser(with: userID, completion:  { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        })

    }
    
    
    func fetchUsers() {
        
        guard let viewingMode = self.viewingMode else { return  }
        guard let ref = getDatabaceReference() else { return }
        
        switch viewingMode {
        case .followers, .following:
            guard let uid = self.uid else { return }
            
            if followKey == nil {
                
                ref.child(uid).queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach({ (snapshot) in
                        let followId = snapshot.key
                        self.fetchUser(with: followId)
                    })
                    self.followKey = first.key
                })
            } else {
                ref.child(uid).queryOrderedByKey().queryEnding(atValue: self.followKey).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach({ (snapshot) in
                        let followId = snapshot.key

                        if followId != self.followKey {
                            self.fetchUser(with: followId)
                        }
                    })
                    self.followKey = first.key
                })
            }
        case .Likes:
            guard let postId = self.postID else { return }
            
            if likeKey == nil {
                
                ref.child(postId).queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach({ (snapshot) in
                        let likeUid = snapshot.key
                        self.fetchUser(with: likeUid)
                    })
                    self.likeKey = first.key
                })
            } else {
                ref.child(postId).queryOrderedByKey().queryEnding(atValue: self.likeKey).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach({ (snapshot) in
                        let likeUid = snapshot.key
                        if likeUid != self.likeKey {
                            self.fetchUser(with: likeUid)
                        }
                    })
                    self.likeKey = first.key
                })
            }
        }
    }
}
