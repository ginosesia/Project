//
//  UserProfileVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//
import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"



class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate, UITabBarControllerDelegate {
    
    
    // MARK: Properties
    var user: User?
    var posts = [Post]()
    weak var profileCellDelegate: ProfileHeader?
    var viewedUser: User?
    
    var imageSelected = false
    var key: String?
    let cellId = "cellId"

  
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //fetch users data
        if user == nil {
            fetchUsersData()
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(UINib(nibName: headerIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        //change font of the nav title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
        fetchPosts()
    }
    

    //MARK: - UICollectionViewFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 260)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
            header.delegate = self
            header.user = user
            return header
        }
        else {
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width/3)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    //MARK: - Handlers
    
    func handleScrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionView.ScrollPosition(), animated: true)
    }
    
    func handleEditFollowTapped(for header: ProfileHeader) {
        guard let user = header.user else { return }
        if header.editProfileFollowButton.titleLabel?.text == "Settings" {
            
            let editProfileController = EditProfileController()
            editProfileController.user = user
            editProfileController.userProfileController = self
            let navigationController = UINavigationController(rootViewController: editProfileController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        } else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                Utilities.styleFollowButton(header.editProfileFollowButton, following: true)
                user.follow()
                print("following user")
            }  else {
                Utilities.styleFollowButton(header.editProfileFollowButton, following: false)
                user.unfollow()
                print("unfollowed user")
            }
        }
    }
    
    func handleStoreTapped(for header: ProfileHeader) {
    }
        
    func handleMessageUserTapped(for header: ProfileHeader) {
        print("message user")
    }
    
    func handleMoreTapped(for header: ProfileHeader) {
        print("More tapped")
    }
    
    func handleSeeLikesTapped(for header: ProfileHeader) {
        print("tapped")
    }
    
    
    
    func handleFollowersTapped(for header: ProfileHeader) {
        
        let followersVC = FollowLikeVC()
        followersVC.viewingMode = FollowLikeVC.ViewingMode(index: 1)
        followersVC.uid = user?.uid
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func handleFollowingTapped(for header: ProfileHeader) {
        let followingVC = FollowLikeVC()
        followingVC.viewingMode = FollowLikeVC.ViewingMode(index: 0)
        followingVC.uid = user?.uid
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func handleSelectProfilePhoto(for header: ProfileHeader) {
        print("UserProfileVC Line 166")
    }
    
    func handleEditBannerTapped(for header: ProfileHeader) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func handleUploadsTaped(for header: ProfileHeader) {
        print("Uploads")
    }
    
   
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                //Attempt to sign out
                try Auth.auth().signOut()
                //present log in controller
                let logInVC = SignInVC()
                let navController = UINavigationController(rootViewController: logInVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
                print("User signed out.")
            } catch {
                print("Failed: User still signed in.")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
  
    
    // MARK: - API
    
    func fetchPosts() {

        var uid: String!
        
        if let user = self.user {
            uid = user.uid
        } else {
            uid = Auth.auth().currentUser?.uid
        }

        if key == nil {
            USER_POSTS_REF.child(uid).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }

                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    self.fetchPost(with: postId)
                })
                self.key = first.key
            })
        } else {
            USER_POSTS_REF.child(uid).queryOrderedByKey().queryEnding(atValue: self.key).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in

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

        Database.fetchPost(with: postId) { (post) in
            self.posts.append(post)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView.reloadData()
        }
    }
    
    func setUserStats(for header: ProfileHeader) {
        
        guard let uid = header.user?.uid else { return }
        
        var followers: Int!
        var following: Int!
        var uploads: Int!
        
        //get number of followers
        USER_FOLLOWER_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                followers = snapshot.count
            } else {
                followers = 0
            }
            let attributedText = NSMutableAttributedString(string: "\(followers!)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 27)),NSAttributedString.Key.foregroundColor:UIColor.white])
            attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            header.followersLabel.attributedText = attributedText
        }
        
        //get number of uploads
        USER_POSTS_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                uploads = snapshot.count
            } else {
                uploads = 0
            }
            let attributedText = NSMutableAttributedString(string: "\(uploads!)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 27)),NSAttributedString.Key.foregroundColor:UIColor.white])
            attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            header.postsLabel.attributedText = attributedText
        }
        
        //get number of following
        USER_FOLLOWING_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                following = snapshot.count
            } else {
                following = 0
            }
            let attributedText = NSMutableAttributedString(string: "\(following!)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 27)),NSAttributedString.Key.foregroundColor:UIColor.white])
            attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            header.followingLabel.attributedText = attributedText
        }
    }
    
    func fetchUsersData() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("Users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: userDictionary)
            self.user = user
            //self.navigationItem.title = user.username
            self.navigationController?.navigationBar.isHidden = true
            //Stop Refreshing
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView?.reloadData()
        })
    }
}
