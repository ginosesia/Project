//
//  AppDelegate.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        FirebaseApp.configure()
        
      //  window = UIWindow(frame: UIScreen.main.bounds)
        //window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: MainTabVC())
        
        //attempToRegisterForNotifications(application: application)
    
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.

    }

    func attempToRegisterForNotifications(application: UIApplication) {
        
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert,.badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (authorized, err) in
            print("**** Notifications registered ****")
        }
        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("**** DEBUG: Registered for notifications with device token: ", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("DEBUG: Registered with FCM Token: ", fcmToken)
    }
}
