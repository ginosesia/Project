//
//  UploadItem.swift
//  SocialApp
//
//  Created by Gino Sesia on 26/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class UploadItem: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    var imageSelected = false

    let image: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        button.setTitle("Add Picture", for: .normal)
        button.tintColor = Utilities.setThemeColor()
        return button
    }()
        
    let itemTitleTextView: UITextField = {
        let textView = UITextField()
        Utilities.styleTextField(textView, name: "Product Title")
        return textView
    }()
    
    let itemPriceTextView: UITextField = {
        let textView = UITextField()
        Utilities.styleTextField(textView, name: "Price")
        return textView
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)

        setNavButtons()
        setElements()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }


    //MARK: - Views
    
    func setElements() {
        view.addSubview(image)
        let height = (navigationController?.navigationBar.frame.height)! + 50
        let width = view.frame.width/2.8
        image.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: height, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: width)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = width/2
        
        view.addSubview(itemTitleTextView)
        itemTitleTextView.anchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        view.addSubview(itemPriceTextView)
        itemPriceTextView.anchor(top: itemTitleTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
    }
    
    func setNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,target: self, action:  #selector(handleCancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePostItem))
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()
        navigationController?.navigationBar.barTintColor = .black
    }
    
    //MARL: - Handlers
    
    @objc func handlePostItem() {
        
        
        
        guard let title = itemTitleTextView.text else { return }
        guard let price = itemPriceTextView.text else { return }
        guard let image = self.image.imageView?.image else { return }

        //image upload gata
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        //update storage
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_POST_IMAGES_REF.child(filename)
        
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            
            // handle error
            if let error = error {
                print("Failed to upload image to storage with error", error.localizedDescription)
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                
                // post data
                let values = ["title": title,
                              "creationDate": creationDate,
                              "price": price,
                              "imageUrl": imageUrl] as [String: Any]
                
                //post id
                let itemId = ITEMS_REF.childByAutoId()
                guard let itemKey = itemId.key else { return }
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                //upload information to database
                USER_ITEMS_REF.child(uid).updateChildValues([itemKey: 1])
                    
                ITEMS_REF.child(itemKey).setValue(values)
                
                self.dismiss(animated: true, completion: nil)
            })
        }
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
        image.layer.masksToBounds = true
        image.setImage(profilePicture.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
