//
//  SettingsSection.swift
//  SocialApp
//
//  Created by Gino Sesia on 04/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import Firebase
import UIKit



enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Social
    case Communications
    case Account
    
    
    
    var description: String {
        switch self {
            
        case.Social: return "Info"
        case.Communications: return "Communications"
        case.Account: return "Account"
            
        }
    }
}


enum SocialOptions: Int, CaseIterable, SectionType {
    var containsSwitch: Bool { return false }
    
    
    case editUserName
    case editFirstname
    case editSurname
    case editEmail
    case editPassword
    case editProfileImage1
    
    
    var description: String {
        switch self {
            
        case.editUserName: return "Username"
        case.editFirstname: return "Firstname"
        case.editSurname: return "Surname"
        case.editEmail: return "Email"
        case.editPassword: return "Change Password"
        case.editProfileImage1: return "Change Profile Picture"
            
        }
    }
}


enum CommunicationsOptions: Int, CaseIterable, SectionType {
    
    case notifications
    case email
    case reportCrashes
    
    var description: String {
        switch self {
        case.notifications: return "Notifications"
        case.email: return "Email"
        case.reportCrashes: return "Report Crashes"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .notifications: return true
        case .email: return true
        case.reportCrashes: return true
        }
    }
}


enum AccountOptions: Int, CaseIterable, SectionType {
    var containsSwitch: Bool { return false }
    
    case help
    case addAccount
    case delete
    case logout
    case space1
    case space2
    
    
    var description: String {
        switch self {
        case.help: return "Help"
        case.addAccount: return "Add Account"
        case.delete: return "Delete Account"
        case.logout: return "Logout"
        case.space1: return " "
        case.space2: return " "
            
        }
    }
}
