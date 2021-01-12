//
//  ForgotPasswordVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    
    var EMAIL: String = "Email"
    var WHITESPACE: String = ""
    var FILL_IN_EMAIL: String = "Please fill in your email address"
    var INVALID_EMAIL: String = "Please enter a valid email address. For example johndoe@domain.com"
    var RESET_EMAIL: String = "Reset email has been sent"
    
    
    let forgotPassword: UILabel = {
        let logo = UILabel()
        logo.text = "FORGOT PASSWORD"
        logo.textColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        logo.textAlignment = .center
        logo.font = UIFont.boldSystemFont(ofSize: 15)
        return logo
    }()

     
     let emailTextField: UITextField = {
         let email = UITextField()
         email.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
         Utilities.styleTextField(email, name: "Email")
         return email
     }()
    
    let resetPasswordButton: UIButton = {
           let button = UIButton(type: .system)
           Utilities.styleFilledButton(button, name: "Reset password")
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
           return button
       }()
    
    @objc func resetPassword() {

          let error = validatFields()
          if error != nil {
             //There's somthing wrong with the fields, show error message
              showError(error!)
          }
          else {
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             
              Utilities.resetPassword(email: email, resetCompletion: { (result) in
                  switch result{
                  case .failure(let error):
                    self.errorLabel.text = error.localizedDescription
                  case .success( _):
                      break
                  }
                  self.errorLabel.text = self.RESET_EMAIL
                  self.errorLabel.textColor = UIColor.green
                  self.errorLabel.alpha = 1
              })
              
              
          }
        
        
       }
    
    
       
    let returnToSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Return to Sign in?", for: .normal)
        button.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()
          
    @objc func handleShowSignIn() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    let errorLabel: UILabel = {
          let error = UILabel()
           error.alpha = 0
           error.textColor = .red
           error.text = "Error"
            error.font = error.font.withSize(15)
           error.textAlignment = .center
        error.numberOfLines = 0

           return error
       }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        view.addSubview(forgotPassword)
        forgotPassword.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        forgotPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        configureViewConponents()
        
        view.addSubview(returnToSignInButton)
        returnToSignInButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 0, width: 0, height: 50)

    }
    
    func configureViewConponents() {
         let stackView = UIStackView(arrangedSubviews: [emailTextField,resetPasswordButton,errorLabel])
         stackView.axis = .vertical
         stackView.spacing = 10
         stackView.distribution = .fillEqually
         
         view.addSubview(stackView)
         stackView.anchor(top: forgotPassword.bottomAnchor
             , left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 350, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
        
     }
    
    func validatFields() -> String? {
           //check that all fields are filled in
           if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE {
               return FILL_IN_EMAIL
           }
                let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                  if Utilities.isValidEmail(cleanedEmail) == false {
                        return INVALID_EMAIL
                    }
           return nil
       }

    func cleanTextFields() {
           emailTextField.text = WHITESPACE

       }
       
       func dismissKeyboard() {
              self.view.endEditing(false)
          }
       
       func showError(_ message:String) {
           errorLabel.text = message
           errorLabel.alpha = 1
       }
   

}
