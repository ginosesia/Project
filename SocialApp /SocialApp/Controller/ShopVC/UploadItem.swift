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
    var WHITESPACE: String = ""


    let image: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        button.setTitle("Add Picture", for: .normal)
        button.tintColor = Utilities.setThemeColor()
        return button
    }()
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title:"
        label.textColor = Utilities.setThemeColor()
        label.font = label.font?.withSize(14)
        return label
    }()
    
    let itemTitleTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.backgroundColor = UIColor(white: 1, alpha: 0.15)
        textView.layer.cornerRadius = 10
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 20)
        return textView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        label.textColor = Utilities.setThemeColor()
        label.font = label.font?.withSize(14)
        return label
    }()
    
    let itemDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.backgroundColor = UIColor(white: 1, alpha: 0.15)
        textView.layer.cornerRadius = 10
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 20)
        return textView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price:"
        label.textColor = Utilities.setThemeColor()
        label.font = label.font?.withSize(14)
        return label
    }()
    
    let itemPriceTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.backgroundColor = UIColor(white: 1, alpha: 0.15)
        textView.layer.cornerRadius = 10
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 20)
        textView.keyboardType = .numbersAndPunctuation
        return textView
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantity:"
        label.textColor = Utilities.setThemeColor()
        label.font = label.font?.withSize(14)
        return label
    }()
    
    let itemStockTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.backgroundColor = UIColor(white: 1, alpha: 0.15)
        textView.layer.cornerRadius = 10
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 20)
        textView.keyboardType = .numbersAndPunctuation
        return textView
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Invalid Price"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.alpha = 0
        return label
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
        
        //Product Image
        view.addSubview(image)
        let height = (navigationController?.navigationBar.frame.height)! + 50
        let width = view.frame.width/2.8
        image.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: height, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: width)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = width/2
        //Title Label
        view.addSubview(titleLabel)
        titleLabel.anchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 25, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        //Title Text View
        view.addSubview(itemTitleTextView)
        itemTitleTextView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        //Price Label
        view.addSubview(priceLabel)
        priceLabel.anchor(top: itemTitleTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        //Price Text View
        view.addSubview(itemPriceTextView)
        let priceWidth = view.frame.width/2.5
        itemPriceTextView.anchor(top: priceLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: priceWidth, height: 40)

        //Stock Label
        view.addSubview(stockLabel)
        //Stock Text View
        view.addSubview(itemStockTextView)
        itemStockTextView.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: priceWidth, height: 40)
        stockLabel.anchor(top: nil, left: itemStockTextView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        stockLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        itemStockTextView.centerYAnchor.constraint(equalTo: itemPriceTextView.centerYAnchor).isActive = true

        //Error Label
        view.addSubview(errorLabel)
        errorLabel.anchor(top: nil, left: nil, bottom: image.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        //Description Label
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: itemPriceTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 25, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        //Description Text View
        view.addSubview(itemDescriptionTextView)
        itemDescriptionTextView.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 100)
    }
    
    func setNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,target: self, action:  #selector(handleCancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePostItem))
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.title = "New Item"

    }
    
    //MARL: - Handlers
    
    @objc func handlePostItem() {
        
        let error = validateFields()
        if error != nil {
            //Show Error
            showError(error!)
        } else {
            
            guard let title = itemTitleTextView.text else { return }
            guard let price = itemPriceTextView.text else { return }
            guard let image = self.image.imageView?.image else { return }
            guard let description = itemDescriptionTextView.text else { return }
            guard let stock = itemStockTextView.text else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }


            //image upload gata
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            let creationDate = Int(NSDate().timeIntervalSince1970)
            
            //update storage
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_POST_IMAGES_REF.child(filename)
            
            let uploadTask = STORAGE_POST_IMAGES_REF.child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
                
                // handle error
                if let error = error {
                    print("Failed to upload image to storage with error", error.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    guard let imageUrl = url?.absoluteString else { return }
                    
                    // post data
                    let values = ["uid": uid,
                                  "title": title,
                                  "creationDate": creationDate,
                                  "price": price,
                                  "imageUrl": imageUrl,
                                  "description": description,
                                  "quantity": stock] as [String: Any]
                    
                    //post id
                    let itemId = ITEMS_REF.childByAutoId()
                    guard let itemKey = itemId.key else { return }
                    
                    
                    //upload information to database
                    USER_ITEMS_REF.child(uid).updateChildValues([itemKey: 1])
                        
                    ITEMS_REF.child(itemKey).setValue(values)
                    
                    self.dismiss(animated: true, completion: nil)
                })
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                self.view.addSubview(self.activity)
                self.activity.anchor(top: self.image.topAnchor, left: self.image.leftAnchor, bottom: nil, right: self.image.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                self.activity.centerXAnchor.constraint(equalTo: self.image.centerXAnchor).isActive = true
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    
    }
    
    func validateFields() -> String? {
        if itemTitleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE {
            return "Title Required"
        }
        
        if itemPriceTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE {
            return "Price Required"
        }

        if itemStockTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == WHITESPACE {
            return "Quantity Required"
        }

        if !itemPriceTextView.text.isNumeric {
           return "Invalid Price"
        }
        
        if !itemStockTextView.text.isNumeric {
           return "Invalid Quantity"
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    let activity: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()

    
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
