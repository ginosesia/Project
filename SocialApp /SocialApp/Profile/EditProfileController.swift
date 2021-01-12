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
    var bannarImageChanged = false
    var bannerChanged = false
    var usernameChanged = false
    var lastnameChanged = false
    var firstnameChanged = false
    var profilePicture = true
    var userProfileController: UserProfileVC?
    var newUsername: String?
    
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
        button.setTitle("Edit Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileImage), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let editBannerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeBannerImage), for: .touchUpInside)
        return button
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
        return view
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        Utilities.styleTextField(textField, name: "")
        return textField
    }()
    
    let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        Utilities.styleTextField(textField, name: "")
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        Utilities.styleTextField(textField, name: "")
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Fullname"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let surnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Lastname"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Utilities.setThemeColor()
        return label
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
    
    @objc func handleSaveTapped() {
        
        view.endEditing(true)
        if usernameChanged {
            updateUsername(name: newUsername!, type: USERNAME)
        }
        
        if profileImageChanged {
            updateProfileImage()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleChangeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        profilePicture = true
        bannarImageChanged = false
        present(imagePicker, animated: true, completion: nil)
        profileImage.layer.borderWidth = 0
    }
    
    @objc func handleChangeBannerImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        profilePicture = false
        bannarImageChanged = true
        present(imagePicker, animated: true, completion: nil)
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
        
        let fullname = "\(firstname) \(lastname)"
        
        
        fullnameTextField.text = fullname
        usernameTextField.text = user.username
        surnameTextField.text = user.lastname
        
    }
    
    func configureNavBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
        navigationItem.title = "Edit Profile"
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
        editButton.anchor(top: nil, left: nil, bottom: profileImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -12, paddingRight: 0, width: 140, height: 30)
        editButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true

        
        separator.anchor(top: nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1.5)
        
        fullnameLabel.anchor(top: container.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)

        surnameLabel.anchor(top: fullnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        usernameLabel.anchor(top: surnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        fullnameTextField.anchor(top: nil, left: fullnameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 30)
        fullnameTextField.layer.cornerRadius = 6
        fullnameTextField.centerYAnchor.constraint(equalTo: fullnameLabel.centerYAnchor).isActive = true
        
        surnameTextField.anchor(top: nil, left: surnameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 30)
        surnameTextField.layer.cornerRadius = 6
        surnameTextField.centerYAnchor.constraint(equalTo: surnameLabel.centerYAnchor).isActive = true

        
        usernameTextField.anchor(top: nil, left: usernameTextField.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 30)
        usernameTextField.layer.cornerRadius = 6
        usernameTextField.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true

        
    }
    
    func addSubviews(container: UIView) {
        
        container.addSubview(profileImage)
        container.addSubview(separator)
        container.addSubview(editButton)
        container.addSubview(separator)
        
        view.addSubview(fullnameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(fullnameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(usernameTextField)
        
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
 
        //cheack username
        
        guard user.username != trimmedUsernameString else {
            print("ERROR: You did not change your username")
            usernameChanged = false
            return
        }
        
        guard trimmedUsernameString != "" else {
            print("ERROR: Please enter a valid username")
            usernameChanged = false
            return
        }
        

        self.newUsername = trimmedUsernameString?.lowercased()
        usernameChanged = true
        
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
    
    func updateUsername(name updatedName: String, type: Int) {
        
        var nameType: String
        
        if type == USERNAME {
            nameType = "Username"
        } else if type == FIRSTNAME {
            nameType = "Firstname"
        } else {
            nameType = "Surname"
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
