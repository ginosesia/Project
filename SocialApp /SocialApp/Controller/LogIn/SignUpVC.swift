//
//  SignUpVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 27/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    var name: String? = nil
    var WHITESPACE: String = ""
    var USERS: String = "Users"
    var EMAIL: String = "Email"
    var UID: String = "uid"
    var SIGN_UP_BUTTON: String = "Sign Up"
    var PASSWORD: String = "Password"
    var CONFIRM_EMAIL: String = "Confirm email"
    var CONFIRM_PASSWORD: String = "Confirm password"
    var FIRST_NAME: String = "First Name"
    var LAST_NAME: String = "Last Name"
    var USER_NAME: String = "Username"
    var ALL_FIELDS_REQUIRED: String = "Please fill in all fields"
    var TERMS_AND_CONDITIONS: String = "Please agree to terms and conditions!"
    var ERROR: String = "Error"
    var ERROR_CREATING_USER: String = "Email may be in use. Please try another one"
    var ERROR_SAVING_USER: String = "Error saving user data"
    var RESEND: String = "Resend"
    var CANCEL: String = "Cancel"
    var VERIFY_EMAIL: String = "A verification link has been sent to your email account. Please verify your email address and sign in."
    var VERIFIED_EMAIL: String = "Verified your email? Sign in"
    var DIFFERENT_EMAILS: String = "Emails do not match. Try again"
    var DIFFERENT_PASSWORDS: String = "Passwords do not match. Try again"
    var INVALID_EMAIL: String = "Please enter a valid email address. For example johndoe@domain.com"
    var INVALID_PASSWORD: String = "Invalid Password: please make sure your password is at least 8 character, contains a special characters and a number."
    var imageSelected = false
    
    
    let signUp: UILabel = {
        let logo = UILabel()
        logo.text = "SIGN UP"
        logo.textColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        logo.textAlignment = .center
        logo.font = UIFont.boldSystemFont(ofSize: 15)
        return logo
    }()
    
    let profileImage: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 20, green: 20, blue: 20, alpha: 1)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        button.setTitle("Add Picture", for: .normal)
        button.tintColor = Utilities.setThemeColor()
        return button
    }()
    
    let nameTextField: UITextField = {
        let name = UITextField()
        name.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(name, name: "Firstname")
        return name
    }()
    
    let surnameTextField: UITextField = {
        let surname = UITextField()
        surname.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(surname, name: "Surname")
        return surname
    }()
    
    let usernameTextField: UITextField = {
        let username = UITextField()
        username.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(username, name: "Username")
        return username
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField()
        email.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(email, name: "Email")
        return email
    }()
    
    let confirmEmailTextField: UITextField = {
        let email = UITextField()
        email.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(email, name: "Confirm email")
        return email
    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        password.isSecureTextEntry = true
        Utilities.styleTextField(password, name: "Password")
        return password
    }()
    
    let confirmPasswordTextField: UITextField = {
        let password = UITextField()
        password.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        password.isSecureTextEntry = true
        Utilities.styleTextField(password, name: "Confirm password")
        return password
    }()
    
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        Utilities.styleFilledButton(button, name: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let errorLabel: UILabel = {
        let error = UILabel()
        error.alpha = 0
        error.textColor = .red
        error.font = error.font.withSize(15)
        error.textAlignment = .center
        error.numberOfLines = 0
        return error
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already have an account? Sign In", for: .normal)
        button.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()
    
    
    lazy var agreeLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString.init(string: "Terms & Conditions")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        label.attributedText = attributedString
        label.textColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 0.8)
        let termsAndConditionsTapped = UITapGestureRecognizer(target: self, action: #selector(TermsAndConditionsTapped))
        termsAndConditionsTapped.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(termsAndConditionsTapped)
        label.textAlignment = .center
        return label
    }()
    
    let termsAndConditionsBox: UISwitch = {
        let switchA = UISwitch()
        switchA.onTintColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 0.5)
        return switchA
    }()
    
    func setAgreeSwitch(value: Bool) {
        termsAndConditionsBox.isOn = value
    }
    
    @objc func TermsAndConditionsTapped() {
        let termsAndConditions = TermsAndConditionsVC()
        let navController = UINavigationController(rootViewController: termsAndConditions)
        termsAndConditions.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    
    private var authUser : Firebase.User? {
        return Auth.auth().currentUser
    }
    
    //MARK: - Handlers
    
    @objc func handleSelectProfilePhoto() {
        // configure image picker
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profilePicture = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = true
            return
        }
        imageSelected = true
        profileImage.layer.masksToBounds = true
        profileImage.setImage(profilePicture.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSignUp() {
        //Validate the fields
        let error = validatFields()
        if error != nil {
            //There's somthing wrong with the fields, show error message
            showError(error!)
        } else {
            //Create cleaned versions of the data
            let firstname = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let surname = surnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //Check for errors
                if err != nil {
                    //There was an error creating the user
                    self.showError(self.ERROR_CREATING_USER)
                } else {
                    //User created successfully
                    self.errorLabel.alpha = 0
                    guard let profileImg = self.profileImage.imageView?.image else { return }
                    guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }
                    //place image in firebase
                    let fileName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("Profile_Image").child(fileName)
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if let error = error {
                            print("Failed to upload  image with error: " , error.localizedDescription)
                            return
                        }
                        storageRef.downloadURL(completion: { (downloadURL, error) in
                            guard let profileImageUrl = downloadURL?.absoluteString  else {
                                print("DEBUG: Profile image url is nil")
                                return
                            }
                            
                            let dictionary = ["Firstname": firstname,
                                              "Surname": surname,
                                              "Username": username,
                                              "Email": email,
                                              "Bio": "Bio",
                                              "myStore": "false",
                                              "Description": "Description",
                                              "Terms&Conditions": "true",
                                              "profileImageUrl": profileImageUrl] as [String : Any]
                            
                            let uid = result!.user.uid
                            let values = [uid: dictionary]
                            
                            USER_REF.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                print("Successfully created user")
                            })
                            
                        })
                    })
                    
                    self.cleanTextFields()
                    self.dismissKeyboard()
                    self.sendVerificationMail()
                    self.errorLabel.text = self.VERIFY_EMAIL
                    self.errorLabel.textColor = UIColor.green
                    self.errorLabel.alpha = 1
                    self.signInButton.setTitle(self.VERIFIED_EMAIL, for: .normal)
                    self.profileImage.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
    }
    
    @objc func handleShowSignIn() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide nav bar
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        view.addSubview(signUp)
        signUp.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        signUp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        configureViewConponents()
        view.addSubview(signInButton)
        signInButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 0, width: 0, height: 50)
        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)
        
    }
    
    
    func configureViewConponents() {
        
        let agreeView = UIStackView(arrangedSubviews: [agreeLabel,termsAndConditionsBox])
        agreeView.axis = .horizontal
        agreeView.distribution = .fillProportionally
        agreeView.alignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [nameTextField,surnameTextField,usernameTextField,emailTextField,confirmEmailTextField,passwordTextField,confirmPasswordTextField,agreeView,signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(profileImage)
        profileImage.anchor(top: signUp.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 105, height: 105)
        profileImage.layer.cornerRadius = 50
        profileImage.centerXAnchor.constraint(equalTo: signUp.centerXAnchor).isActive = true
        
        
        view.addSubview(stackView)
        stackView.anchor(top: profileImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 470)
        view.addSubview(errorLabel)
        errorLabel.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 70)
        
    }
    
    
    func validatFields() -> String? {
        //check that all fields are filled in
        
        
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE || surnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE || usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE || confirmEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE {
            return ALL_FIELDS_REQUIRED
        }
        
        if termsAndConditionsBox.isOn == false {
            return TERMS_AND_CONDITIONS
        }
        
        let cleanedPassword =  passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //Password is not secure enough
            return INVALID_PASSWORD
        }
        
        
        if Utilities.isValidEmail(cleanedEmail) == false {
            return INVALID_EMAIL
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != confirmEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return DIFFERENT_EMAILS
        }
        
        
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return DIFFERENT_PASSWORDS
        }
        
        errorLabel.alpha = 0
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func cleanTextFields() {
        emailTextField.text = WHITESPACE
        passwordTextField.text = WHITESPACE
        nameTextField.text = WHITESPACE
        surnameTextField.text = WHITESPACE
        usernameTextField.text = WHITESPACE
        confirmEmailTextField.text = WHITESPACE
        confirmPasswordTextField.text = WHITESPACE
        profileImage.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        profileImage.layer.borderWidth = 0
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
            })
        } else {
            errorLabel.text = "Error sending email please try again"
            errorLabel.alpha = 1
            print("Error sending email please try again")
        }
    }
}
