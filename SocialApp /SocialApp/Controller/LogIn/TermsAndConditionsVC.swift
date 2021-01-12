//
//  File.swift
//  SocialApp
//
//  Created by Gino Sesia on 08/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//  https://dmtopolog.com/navigation-bar-customization/

import Foundation
import UIKit

class TermsAndConditionsVC: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    weak var delegate: SignUpVC?
    
    
    //MARK: - Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setBarButtons()
    }

    func setBarButtons() {
        navigationItem.title = "Terms & Conditions"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Disagree", style: .plain, target: self, action: #selector(handleDisagreeTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Agree", style: .plain, target: self, action: #selector(handleAgreeTapped))
        
//        navigationController?.navigationBar.titleTextAttributes = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont(name: "mplus-1c-regular", size: 21)!
//        ]

        
//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAgreeTapped))
//        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(handleAgreeTapped))
//        navigationItem.rightBarButtonItems = [add, play]
    }
    
     
    @objc func handleAgreeTapped() {
        delegate?.setAgreeSwitch(value: true)
        self.dismiss(animated: true, completion: nil)
    }
  
    @objc func handleDisagreeTapped() {
            
        let signUpVC = SignUpVC()
        let alertVC = UIAlertController(title: "Terms & Conditions", message: "If you do not agree you cannot sign up and log in to Social App", preferredStyle: .alert)
            
        let alertActionOkay = UIAlertAction(title: "Disagree", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.setAgreeSwitch(value: false)
            signUpVC.cleanTextFields()
        }
         
        let alertActionCancel = UIAlertAction(title: "Agree", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.setAgreeSwitch(value: true)
        }
         
        alertVC.addAction(alertActionOkay)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
     

}
