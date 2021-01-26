//
//  MainTabVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate, SettingsLauncherDelegate {
    
    
    //MARK: - Properties
    var menuController: UIViewController!
    var centerController: UIViewController!
    var isExpanded = false
    var notificationIds = [String]()
    let dot = UIView()
    var searchBar = UISearchBar()
    var isSearchMode = false
    var isMember = false
    var user: User?
    let settingsLauncher = SettingsLauncher()
    let uploadLauncher = UploadLauncher()

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.barTintColor = .black
        configureTitle()
                
        settingsLauncher.delegate = self
        uploadLauncher.delegate = self

        //Check if user is signed in
        checkIfUserIsLoggedIn()
        
        addNotificationDot()
        //observe notifications
        observeNotifications()
        
        //Set up View Controllers
        configureViewControllers()
        setupNavBar()
                
    }
    
    func configureTitle() {
        let width = view.frame.width
        
        let titleView = UIView()
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
        navigationItem.titleView = titleView
        let label = UILabel()
        label.text = "Social App"
        label.textColor = Utilities.setThemeColor()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        titleView.addSubview(label)
        label.anchor(top: titleView.topAnchor, left: nil, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }

    
    func configureViewControllers() {
        
        
        //Home Feed Controller
        let feedVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        feedVC.title = "Feed"
        
        //Search Feed Controller
        let info = UIImage(systemName: "info")
        let discover = constructNavController(unselectedImage: info!, selectedImage: info!, rootViewController: DiscoverVC())
        discover.navigationBar.isHidden = true
        discover.title = "Discover"
        
        //Post Controller
        let selectImageVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        selectImageVC.title = "New Post"
        
        let selectMessageVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "send2"), selectedImage: #imageLiteral(resourceName: "send2"), rootViewController: MessagesController())
        selectMessageVC.title = "Messages"
        
        //Notification Controller
        let shop = UIImage(systemName: "bag")
        let shopVC = constructNavController(unselectedImage: shop!, selectedImage: shop!, rootViewController: ShopVC(collectionViewLayout: UICollectionViewFlowLayout()))
        shopVC.title = "Shop"
        
        //Profile Controller
        let userProfileVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        userProfileVC.title = "Profile"
        userProfileVC.navigationBar.isHidden = true
        
        // view controllers to be added to tab controller
        viewControllers = [discover, feedVC, shopVC, selectMessageVC, userProfileVC]
        
        // tab bar tint color
        tabBar.tintColor = .white
    }
    
    func addNotificationDot() {

        if UIDevice().userInterfaceIdiom == .phone {
            let tabBarHeight = tabBar.frame.height
            if UIScreen.main.nativeBounds.height == 2436 {
                //configure iphone X
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - tabBarHeight, width: 6, height: 6)
            } else {
                //Configure other models
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - 16, width: 6, height: 6)
            }

            let number1 = view.frame.width / 5 * 3
            let number2 = (view.frame.width / 5) / 2

            dot.center.x = number1 + number2
            dot.center.y = number1 + 620
            dot.backgroundColor = UIColor(red: 233/255, green: 30/255, blue: 90/255, alpha: 1)
            dot.layer.cornerRadius = dot.frame.width / 2
            self.view.addSubview(dot)
            dot.isHidden = true

        }
    }
    
    
    func observeNotifications() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.notificationIds.removeAll()
        
        NOTIFICATIONS_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            let notificationId = snapshot.key
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach { (snapshot) in
                NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let checked = snapshot.value as? Int else { return }
                    
                    if checked == 0 {
                        self.dot.isHidden = false
                        
                    } else {
                        self.dot.isHidden = true
                    }
                })
            }
        }
    }
    
    func constructNavController(unselectedImage: UIImage,selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    
    func setupNavBar() {
        let Settings = UIImage(systemName: "gear")
        let moreButton = UIBarButtonItem(image: Settings, style: .plain, target: self, action: #selector(handleMoreTapped))

        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItems = [moreButton, camera]
    }
    
    
    @objc func handleSettings() {
        uploadLauncher.showSettings()
    }
    
    
    @objc func handleMoreTapped() {
        settingsLauncher.showSettings()
    }
    
    
    func settingDidSelected(setting: Setting) {
        if setting.name == "Search User" {
            let searchVC = SearchVC()
            let navigationController = UINavigationController(rootViewController: searchVC)
            navigationController.title = "Search User"
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        } else if setting.name == "My Store" {
            self.checkIfMember()
        } else if setting.name == "Notifications" {
            let notifications = NotificationsVC()
            self.navigationController?.pushViewController(notifications, animated: true)
        } else if setting.name == "Settings" {
            let settingsVC = SettingsVC()
            self.navigationController?.pushViewController(settingsVC, animated: true)
        } else if setting.name == "Picture" {
            let selectImageVC = SelectPostVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
            self.present(navController, animated: true, completion: nil)
        } else if setting.name == "Video" {
            let selectVideoVC = SelectVideoVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectVideoVC)
            self.present(navController, animated: true, completion: nil)
        } else if setting.name == "Message" {
            let messageVC = UploadMessageVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: messageVC)
            self.present(navController, animated: true, completion: nil)
        } else if setting.name == "Sign Out" {
            do {
                //Attempt to sign out
                try Auth.auth().signOut()
                //present log in controller
                let logInVC = SignInVC()
                let navController = UINavigationController(rootViewController: logInVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                } catch {
                print("Failed: User still signed in.")
            }
        }
    }
    
    func checkIfMember() {
        let uid = Auth.auth().currentUser?.uid

        STORE_REF.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(uid!) {
                let store = MyStore(collectionViewLayout: UICollectionViewFlowLayout())
                self.navigationController?.pushViewController(store, animated: true)
            } else {
                let store = JoinShopVC()
                let navController = UINavigationController(rootViewController: store)
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
    
   func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            print("No user signed in")
            DispatchQueue.main.async {
                let logInVC = SignInVC()
                let navController = UINavigationController(rootViewController: logInVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            print("User signed in")
        }
        return
    }
}
