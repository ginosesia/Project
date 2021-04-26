//
//  Utilities.swift
//
//  Created by Gino Sesia on 04/06/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Utilities {
    
    
    //MARK: - Follow Button
    static func styleFollowButton(_ button: UIButton, following:Bool) {
        
        if following {
            button.setTitle("Following", for: .normal)
            button.backgroundColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            button.layer.cornerRadius = 12
        }  else {
            button.setTitle("Follow", for: .normal)
            button.backgroundColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            button.layer.cornerRadius = 12
        }
    }
    
    //MARK: - Theme Colour
    static func setThemeColor() -> UIColor {
        return UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
    }
    
    
    //MARK: - Profile Seperator Buttons
    static func buttonPressed(_ selectedButton: UIButton,_ unselectedButton1: UIButton,_ unselectedButton2: UIButton) {
       
        selectedButton.tintColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
        selectedButton.layer.backgroundColor = UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1).cgColor
        selectedButton.layer.cornerRadius = 12

        unselectedButton1.tintColor = .white
        unselectedButton1.layer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        unselectedButton2.tintColor = .white
        unselectedButton2.layer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
    }
    
    //MARK: - EditProfile Button

    static func styleEditProfileButton(_ button: UIButton) {
        button.setTitle("Settings", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)

    }
    
    static func styleStoreButton(_ button: UIButton) {
        button.backgroundColor = UIColor.black
        let shop = UIImage(systemName: "bag")
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setImage(shop, for: .normal)
    }
    
    //MARK: - Text Field
    static func styleTextField(_ textfield:UITextField, name:String) {
        
        textfield.attributedPlaceholder = NSAttributedString(string: name,attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        textfield.backgroundColor = UIColor(white: 1, alpha: 0.1)
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
        if name != "" {
            textfield.layer.cornerRadius = 10
        }
        textfield.font = textfield.font?.withSize(15)
    }
    
    //MARK: - Button

    static func styleFilledButton(_ button:UIButton, name:String) {
        
        button.setTitle(name, for: .normal)
        button.backgroundColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 0.6)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    //MARK: - Check Password
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
        
    //MARK: - Check Email
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //MARK: - Reset Password
    static func resetPassword(email: String, resetCompletion:@escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                resetCompletion(.failure(error))
            } else {
                resetCompletion(.success(true))
            }
        })
    }
}
