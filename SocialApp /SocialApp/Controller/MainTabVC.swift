//
//  MainTabVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Properties
    var menuController: UIViewController!
    var centerController: UIViewController!
    var isExpanded = false
    var notificationIds = [String]()
    let dot = UIView()
    var searchBar = UISearchBar()
    var isSearchMode = false
    var isMember = true

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.barTintColor = .black

        navigationItem.title = "Messages"
        
        //Check if user is signed in
        checkIfUserIsLoggedIn()
        //set title
        //setTitle(title: "Social App")
        
        addNotificationDot()
        //observe notifications
        observeNotifications()
        
        //Set up View Controllers
        configureViewControllers()
        setupNavBar()
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
        navigationBarAppearace.barTintColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
    }
    
    
    func setTitle(title: String) {
        navigationItem.title = title
    }
    
    func configureViewControllers() {
        
        
        //Home Feed Controller
        let feedVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        feedVC.title = "Feed"
        
        //Search Feed Controller
        let info = UIImage(systemName: "info")
        let infoVC = constructNavController(unselectedImage: info!, selectedImage: info!, rootViewController: SearchVC())
        infoVC.title = "Discover"
        
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
        
        // view controllers to be added to tab controller
        viewControllers = [infoVC, feedVC, shopVC, selectMessageVC, userProfileVC]
        
        // tab bar tint color
        tabBar.tintColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
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
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            if !isMember {
                let shopVC = JoinShopVC()
                present(shopVC, animated: true, completion: nil)
            }
        } else if index == 3 {
            
        }
        
        return true
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
        navController.navigationBar.tintColor = .black
        return navController
    }
    
    
    func setupNavBar() {
        let Settings = UIImage(systemName: "gear")
        let moreButton = UIBarButtonItem(image: Settings, style: .plain, target: self, action: #selector(handleMoreTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchForUser))

        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleSettings))
        
        navigationItem.rightBarButtonItems = [moreButton,searchButton]
        navigationItem.leftBarButtonItem = camera
    }
    
    //MARK: - Search Bar
    @objc func searchForUser() {
        configureSearchBar()
    }
    
    @objc func cancelSearchForUser() {
        searchBar.isHidden = true
    }
    
    @objc func cancelSearch() {
        print("dismiss")
    }
    
    func configureSearchBar() {
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.tintColor = UIColor(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
        view.backgroundColor = .black
                
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = true
        isSearchMode = false
        searchBar.text = nil
    }
    
    @objc func handleSettings() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 0.5)
        alertController.view.tintColor = Utilities.setThemeColor()
        
        alertController.addAction(UIAlertAction(title: "Upload Picture", style: .default, handler: { (menu) in
            let selectImageVC = SelectPostVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
            self.present(navController, animated: true, completion: nil)

        }))
        alertController.addAction(UIAlertAction(title: "Upload Video", style: .default, handler: { (menu) in
            let selectVideoVC = SelectVideoVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectVideoVC)
            self.present(navController, animated: true, completion: nil)

        }))
        alertController.addAction(UIAlertAction(title: "Upload Message", style: .default, handler: { (menu) in
            let messageVC = UploadMessageVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: messageVC)
            self.present(navController, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (menu) in
            self.dismiss(animated: true, completion: nil)

        }))
        self.present(alertController, animated: true)        
    }
    
    @objc func handleMoreTapped() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 0.5)
        alertController.view.tintColor = Utilities.setThemeColor()
        
        alertController.addAction(UIAlertAction(title: "Profile Settings", style: .default, handler: { (menu) in
            let settingsVC = SettingsVC()
            self.navigationController?.pushViewController(settingsVC, animated: true)
            
        }))

        alertController.addAction(UIAlertAction(title: "My Store", style: .default, handler: { (menu) in
            
            let myStore = MyStoreVC()
            let navigationController = UINavigationController(rootViewController: myStore)
            navigationController.modalPresentationCapturesStatusBarAppearance = true
            self.navigationController?.present(myStore, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "More", style: .default, handler: { (menu) in
            print("Menu")
        }))
        
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
        
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alertController, animated: true)
    
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
