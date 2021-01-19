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
    weak var profileCellDelegate: ProfileHeader?
    var viewedUser: User?
    
    var imageSelected = false
    var key: String?
    let cellId = "cellId"
    
    lazy var menuBar: MenuBar = {
        let bar = MenuBar()
        bar.homeControllerProfile = self
        return bar
    }()
    
  
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
        self.collectionView.backgroundColor = .systemPink
        
        //change font of the nav title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        
        collectionView.isScrollEnabled = false
    }
    

    //MARK: - UICollectionViewFlowLayout
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let tabBarHeight = tabBarController?.tabBar.frame.size.height
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height
        let height: CGFloat
        
        if self.user != nil {
             height = view.frame.height
        } else {
             height = view.frame.height-tabBarHeight!-navigationBarHeight!-40

        }
        return CGSize(width: view.frame.width, height: height)
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
            header.myShopButton.isHidden = true

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
