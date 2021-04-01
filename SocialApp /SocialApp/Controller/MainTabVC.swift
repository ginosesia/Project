//
//  MainTabVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class MainTabVC: UITabBarController, UITabBarControllerDelegate, SettingsLauncherDelegate, UIImagePickerControllerDelegate {

    
    
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
        label.font = UIFont.boldSystemFont(ofSize: 30)
        titleView.addSubview(label)
        label.anchor(top: titleView.topAnchor, left: nil, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }

    
    func configureViewControllers() {
        
        
        //FeedVC
        let feedVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        feedVC.navigationBar.isHidden = true
        feedVC.title = "Feed"

        //DiscoverVC
        let info = UIImage(systemName: "heart")
        let discover = constructNavController(unselectedImage: info!, selectedImage: info!, rootViewController: DiscoverVC(collectionViewLayout: UICollectionViewFlowLayout()))
        discover.title = "Discover"
        
        //MessageVC
        let selectMessageVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "send2"), selectedImage: #imageLiteral(resourceName: "send2"), rootViewController: MessagesController())
        selectMessageVC.title = "Messages"
        
        //ShopVC
        let shop = UIImage(systemName: "bag")
        let shopVC = constructNavController(unselectedImage: shop!, selectedImage: shop!, rootViewController: ShopVC(collectionViewLayout: UICollectionViewFlowLayout()))
        shopVC.navigationBar.isHidden = true
        shopVC.title = "Shop"
        
        //ProfileVC
        let userProfileVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        userProfileVC.title = "Profile"
        userProfileVC.navigationBar.isHidden = true
        
        //View controllers to be added to tab controller
        viewControllers = [discover, feedVC, shopVC, selectMessageVC, userProfileVC]
        
        // tab bar tint color
        tabBar.tintColor = Utilities.setThemeColor()
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
            dot.isHidden = false

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
        
        let Settings = UIImage(systemName: "line.horizontal.3")
        let myOrders = UIImage(systemName: "cart")

        let moreButton = UIBarButtonItem(image: Settings, style: .plain, target: self, action: #selector(handleMoreTapped))
        let orders = UIBarButtonItem(image: myOrders, style: .plain, target: self, action: #selector(handleOrdersTapped))
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleSettings))
        
        navigationItem.leftBarButtonItems = [moreButton]
        navigationItem.rightBarButtonItems = [camera, orders]
        navigationItem.title = "App"
    }
    
    @objc func handleSettings() {
        uploadLauncher.showSettings()
    }
    
    
    @objc func handleMoreTapped() {
        settingsLauncher.showSettings()
    }
    
    @objc func handleOrdersTapped() {
        let myOrders = PendingOrders()
        self.navigationController?.pushViewController(myOrders, animated: true)

    }
    
    func settingDidSelected(setting: Setting) {
        if setting.name == "Search User" {
            let searchVC = SearchVC()
            self.navigationController?.pushViewController(searchVC, animated: true)
            searchVC.searchBar.placeholder = "Search User"
            searchVC.searchUsers = true
            searchVC.searchStores = false
        } else if setting.name == "Search Store" {
            let searchVC = SearchVC()
            self.navigationController?.pushViewController(searchVC, animated: true)
            searchVC.searchBar.placeholder = "Search Store"
            searchVC.searchStores = true
            searchVC.searchUsers = false
        } else if setting.name == "My Store" {
            self.checkIfMember()
        } else if setting.name == "Basket" {
            let checkOut = Basket()
            self.navigationController?.pushViewController(checkOut, animated: true)
        } else if setting.name == "Picture" {
            let selectImageVC = SelectPostVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
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
            DispatchQueue.main.async {
                let logInVC = SignInVC()
                let navController = UINavigationController(rootViewController: logInVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        } else {
        }
        return
    }
}
