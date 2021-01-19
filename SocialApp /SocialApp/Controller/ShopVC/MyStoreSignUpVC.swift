//
//  MyStoreVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 02/11/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class MyStoreSignUpVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK: - Properties
    var isMember = false
    var imageSelected = false
    var user: User?
    var WHITESPACE: String = ""
    var ALL_FIELDS_REQUIRED: String = "Please fill in all fields"
    var INVALID_EMAIL: String = "Please enter a valid email address. For example johndoe@domain.com"
   
    let storeImage: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 20, green: 20, blue: 20, alpha: 1)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        button.setTitle("Add Picture", for: .normal)
        button.tintColor = Utilities.setThemeColor()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    let nameTextField: UITextField = {
        let name = UITextField()
        name.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(name, name: "Store Name")
        return name
    }()

    let emailTextField: UITextField = {
        let email = UITextField()
        email.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        Utilities.styleTextField(email, name: "Email")
        return email
    }()

    let joinShop: UIButton = {
        let button = UIButton()
        button.backgroundColor = Utilities.setThemeColor()
        button.setTitle("Join", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
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
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = Utilities.setThemeColor()
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserData()
        
        view.backgroundColor = .black
        
        navigationController?.navigationBar.isHidden = true
        
        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)
        
        setForm()
        
    }
    
    @objc func handleButtonTapped() {
        
        let error = validatFields()
        if error != nil {
            //There's somthing wrong with the fields, show error message
            showError(error!)
        } else {
            let storeName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let storeImg = self.storeImage.imageView?.image else { return }
            guard let uploadData = storeImg.jpegData(compressionQuality: 0.3) else { return }
            //place image in firebase
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Store_Image").child(fileName)
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Failed to upload  image with error: " , error.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (downloadURL, error) in
                    guard let storeImageUrl = downloadURL?.absoluteString  else {
                        print("DEBUG: store image url is nil")
                        return
                    }

                    let dictionary = ["storeName": storeName,
                                      "email": email,
                                      "storeImageUrl": storeImageUrl] as [String : Any]
                    
                    let uid = self.user?.uid
                    let values = [uid: dictionary]
                    
                    STORE_REF.updateChildValues(values) { (error, ref) in
                        print("Store created Successfully")
                        
                        let name = storeName
                        let image = storeImageUrl
                        
                        self.presentSuccessfullyStoreCreated(name: name, image: image)
                    }
                })
            })
        }
    }
    
    func presentSuccessfullyStoreCreated(name: String, image: String) {
        
        
        let storeCreated = StoreCreated()
        storeCreated.name = name
        storeCreated.imageUrl = image
        self.navigationController?.pushViewController(storeCreated, animated: true)

        
    }
    
    func cleanTextFields() {
        emailTextField.text = WHITESPACE
        nameTextField.text = WHITESPACE
    }

    func setSpinner() {
        view.addSubview(spinner)
        spinner.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    
    func validatFields() -> String? {
        //check that all fields are filled in
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE || nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE {
            return ALL_FIELDS_REQUIRED
        }
        
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(cleanedEmail) == false {
            return INVALID_EMAIL
        }
        
        errorLabel.alpha = 0
        return nil
    }


    func setUserData() {
        
        let email = user?.email
        emailTextField.text = email
        
    }
    
    func setForm() {
        
        view.addSubview(storeImage)
        storeImage.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 170, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 130)
        storeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        storeImage.layer.cornerRadius = 65
        
        let stackView = UIStackView(arrangedSubviews: [nameTextField,emailTextField,joinShop])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        stackView.anchor(top: storeImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(errorLabel)
        errorLabel.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 70)

    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
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
        storeImage.layer.masksToBounds = true
        storeImage.setImage(profilePicture.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
}
