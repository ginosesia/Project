//
//  LoginVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    //MARK: - Properties
    var WHITESPACE: String = ""
    var EMAIL: String = "Email"
    var PASSWORD: String = "Password"
    var ALL_FIELDS_REQUIRED: String = "Please fill in all fields"
    var ERROR: String = "Verify Email"
    var RESEND: String = "Resend"
    var CANCEL: String = "Cancel"
    var SIGNING_IN: String = "Email verified. Signing in..."
    var VERIFY_EMAIL: String = "Email address has not yet been verified. Do you want us to send another verification email to "
    
    let signIn: UILabel = {
        let logo = UILabel()
        logo.text = "SIGN IN"
        logo.textColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        logo.textAlignment = .center
        logo.font = UIFont.boldSystemFont(ofSize: 15)
        return logo
    }()
    
    let logo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField()
        email.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(email, name: "Email")
        return email
    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        password.isSecureTextEntry = true
        Utilities.styleTextField(password, name: "Password")
        return password
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        Utilities.styleFilledButton(button, name: "Sign In")
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        return button
    }()
    
    let errorLabel: UILabel = {
        let error = UILabel()
        error.alpha = 0
        error.textColor = .red
        error.text = "Error"
        error.font = error.font.withSize(11)
        error.textAlignment = .center
        error.numberOfLines = 0
        return error
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Handlers
    
    @objc func forgotPassword() {
        let forgotPassword = ForgotPasswordVC()
        self.navigationController?.pushViewController(forgotPassword, animated: true)
        
    }
    
    @objc func logIn() {
        
        //Validate the fields
        
        let error = validatFields()
        
        if error != nil {
            //There's somthing wrong with the fields, show error message
            showError(error!)
            self.errorLabel.text = error
            self.errorLabel.alpha = 1
            print("Failed to log user in")
        } else {
            
            self.errorLabel.alpha = 0
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Sign users in
            Auth.auth().signIn(withEmail: email, password: password) {
                (user, error) in
                if let user = Auth.auth().currentUser {
                    if !user.isEmailVerified {
                        let alertVC = UIAlertController(title: self.ERROR, message: self.VERIFY_EMAIL + " \(email)", preferredStyle: .alert)
                        let alertActionOkay = UIAlertAction(title: self.RESEND, style: .default) {
                            (_) in
                            user.sendEmailVerification(completion: nil)
                        }
                        
                        let alertActionCancel = UIAlertAction(title: self.CANCEL, style: .default, handler: nil)
                        alertVC.addAction(alertActionOkay)
                        alertVC.addAction(alertActionCancel)
                        self.present(alertVC, animated: true, completion: nil)
                        
                    } else {
                        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                            self.cleanTextFields()
                            if error != nil {
                                self.errorLabel.text = error!.localizedDescription
                                self.errorLabel.alpha = 1
                            } else {
                                let mainTabVC = MainTabVC()
                                mainTabVC.modalPresentationStyle = .fullScreen
                                self.present(mainTabVC, animated: true, completion: nil)
                                print("User logged in")
                            }
                        }
                    }
                } else {
                    self.errorLabel.text = error?.localizedDescription
                    self.errorLabel.alpha = 1
                }
            }
        }
    }
    
    
    
    @objc func handleShowSignUp() {
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide nav bar
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        view.addSubview(signIn)
        signIn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: 0)
        signIn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureViewConponents()
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 0, width: 0, height: 50)
    
        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func configureViewConponents() {
        let stackView = UIStackView(arrangedSubviews:
            [emailTextField,passwordTextField,loginButton,forgotPasswordButton,errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: signIn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 300, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 250)
        
    }
    
    func validatFields() -> String? {
        
        //check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE
            || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE {
            
            return ALL_FIELDS_REQUIRED
            
        } else {
            return nil
            
            
        }
        
    }
    
    
    func cleanTextFields() {
        emailTextField.text = WHITESPACE
        passwordTextField.text = WHITESPACE
    }
  
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
