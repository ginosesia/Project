//
//  EditProfileController.swift
//  SocialApp
//
//  Created by Gino Sesia on 30/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Firebase
import UIKit

class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: - Properties
    var user: User?
    var profileImageChanged = false
    var usernameChanged = false
    var lastnameChanged = false
    var firstnameChanged = false
    var bioChanged = false
    var descriptionChanged = false
    var profilePicture = true
    var userProfileController: UserProfileVC?
    var newUsername: String?
    var newBio: String?
    var newDescription: String?
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor.black
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileImage), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
        return view
    }()
    
    let separatorLogout: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
        return view
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.textColor = .white
        Utilities.styleTextField(textField, name: "")
        return textField
    }()
    
    let fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        Utilities.styleTextField(textField, name: "")
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let bioTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.textColor = .white
        Utilities.styleTextField(textField, name: "")
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.textColor = .white
        Utilities.styleTextField(textField, name: "")
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Fullname"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let surnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Lastname"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let signOut: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.rgb(red: 14, green: 104, blue: 206, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background color
        view.backgroundColor = .black
        
        //set delegate
        usernameTextField.delegate = self
        
        //setup nav bar
        configureNavBar()
        
        //configure view
        configureViewComponents()
        
        //load user data
        loadUsersData()
    }
    
    
    
    //MARK: - Handlers
    @objc func handleCancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignOut() {
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

    }
    
    
    @objc func handleSaveTapped() {
        
        view.endEditing(true)
        if usernameChanged {
            updateProfileInfo(name: newUsername!,type: USERNAME)
        }
        
        if profileImageChanged {
            updateProfileImage()
        }
        
        if bioChanged {
            updateProfileInfo(name: newBio!,type: BIO)
        }
        
        if descriptionChanged {
            updateProfileInfo(name: newDescription!,type: DESCRIPTION)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleChangeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        profilePicture = true
        present(imagePicker, animated: true, completion: nil)
        profileImage.layer.borderWidth = 0
    }
    
    
    func loadUsersData() {
        
        guard let user = self.user else { return }
        
        let image = user.profileImageUrl
        
        if image == nil {
            profileImage.loadImage(with: "https://firebasestorage.googleapis.com/v0/b/soc...")
            print("no image")
        } else {
            profileImage.loadImage(with: user.profileImageUrl)
            print("image")
        }
        
        let firstname = user.firstname!
        let lastname = user.lastname!

        let bio = user.bio!
        let description = user.description!

        let fullname = "\(firstname) \(lastname)"
        
        
        fullnameTextField.text = fullname
        usernameTextField.text = user.username
        bioTextField.text = bio
        descriptionTextField.text = description
        
    }
    
    func configureNavBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()
    }
    
    func configureViewComponents() {
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 200)

        let container = UIView(frame: frame)
        view.addSubview(container)
        
        addSubviews(container: container)
        
        let height = CGFloat(120)
        
        profileImage.anchor(top: container.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: height, height: height)
        profileImage.layer.cornerRadius = height/2
        //center image
        profileImage.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        editButton.anchor(top: nil, left: nil, bottom: profileImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -12, paddingRight: 0, width: 120, height: 30)
        editButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true

        
        separator.anchor(top: nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        fullnameLabel.anchor(top: container.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        bioLabel.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)

        descriptionLabel.anchor(top: bioLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)

        fullnameTextField.anchor(top: nil, left: fullnameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        fullnameTextField.layer.cornerRadius = 6
        fullnameTextField.centerYAnchor.constraint(equalTo: fullnameLabel.centerYAnchor).isActive = true
        
        usernameTextField.anchor(top: nil, left: usernameTextField.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        usernameTextField.layer.cornerRadius = 6
        usernameTextField.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true

        bioTextField.anchor(top: nil, left: bioLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        bioTextField.layer.cornerRadius = 6
        bioTextField.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor).isActive = true

        descriptionTextField.anchor(top: nil, left: descriptionLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        descriptionTextField.layer.cornerRadius = 6
        descriptionTextField.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor).isActive = true
        
        separatorLogout.anchor(top: descriptionTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)

        signOut.anchor(top: separatorLogout.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
    }
    
    func addSubviews(container: UIView) {
        
        container.addSubview(profileImage)
        container.addSubview(separator)
        container.addSubview(editButton)
        container.addSubview(separator)
        
        view.addSubview(fullnameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        view.addSubview(signOut)
        view.addSubview(separatorLogout)
        
        view.addSubview(descriptionLabel)
        view.addSubview(fullnameTextField)
        view.addSubview(usernameTextField)
        view.addSubview(bioTextField)
        view.addSubview(descriptionTextField)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
                profileImage.image = selectedImage
                self.profileImageChanged = true
        }
        
        self.profileImageChanged = true
        self.dismiss(animated: true, completion: nil)
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let user = self.user else { return }

        let trimmedUsernameString = usernameTextField.text?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        let trimmedBioString = bioTextField.text
        let trimmedDescriptionString = descriptionTextField.text

        //check username

        guard user.username != trimmedUsernameString || user.bio != trimmedBioString || user.description != trimmedDescriptionString else {
            print("ERROR: You did not change your info")
            usernameChanged = false
            bioChanged = false
            descriptionChanged = false
            return
        }

        guard trimmedUsernameString != "" || trimmedBioString != "" || trimmedDescriptionString != "" else {
            print("ERROR: Please enter a valid info")
            usernameChanged = false
            bioChanged = false
            descriptionChanged = false
            return
        }

        self.newUsername = trimmedUsernameString?.lowercased()
        self.newBio = trimmedBioString?.lowercased()
        self.newDescription = trimmedDescriptionString
        
        usernameChanged = true
        bioChanged = true
        descriptionChanged = true

    }
    
    //MARK: - API
    
    func updateProfileImage() {
        guard profileImageChanged == true else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        Storage.storage().reference(forURL: user.profileImageUrl).delete(completion: nil)
        
        let filename = NSUUID().uuidString
        
        guard let updatedProfileImage = profileImage.image else { return }
        
        guard let imageData = updatedProfileImage.jpegData(compressionQuality: 0.3) else { return }
        
        STORAGE_PROFILE_IMAGES_REF.child(filename).putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print("Failed to upload image to storage with error: ", error.localizedDescription)
            }
            print("1")
            STORAGE_PROFILE_IMAGES_REF.downloadURL(completion: { (downloadURL, error) in
                guard let profileImageUrl = downloadURL?.absoluteString  else {
                   print("DEBUG: Profile image url is nil")
                   return
               }
                
                let dictionry = ["profileImageUrl": profileImageUrl] as [String : Any]
                let values = [currentUid: dictionry]
                
                USER_REF.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    print("Successfully updated image user")
                    guard let userProfileController = self.userProfileController else { return }
                    userProfileController.fetchUsersData()
                    self.dismiss(animated: true, completion: nil)
                })
            })
            print("4")
        }
        print("5")
    }
    

    func updateProfileInfo(name updatedName: String, type: Int) {
        
        let nameType: String
        
        if type == USERNAME {
            nameType = "Username"
        } else if type == BIO {
            nameType = "Bio"
        } else {
            nameType = "Description"
        }
                
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard usernameChanged == true else { return }
        
        USER_REF.child(currentUid).child(nameType).setValue(updatedName) { (err, ref) in
            
            guard let userProfileController = self.userProfileController else { return }
            userProfileController.fetchUsersData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
