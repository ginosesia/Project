//
//  EditStoreItem.swift
//  SocialApp
//
//  Created by Gino Sesia on 26/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class EditStoreItem: UIViewController {
    
    //MARK: - Properties
    
    var item: Item? {
        didSet {
            guard let imageUrl = item?.imageUrl else { return }
            navigationController?.title = item?.itemTitle
            image.loadImage(with: imageUrl)
        }
    }
    
    let image: CustomImageView = {
        let image = CustomImageView()
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    let changeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Utilities.setThemeColor()
        button.setTitle("Change Picture", for: .normal)
        button.layer.cornerRadius = 15
        button.tintColor = .white
        return button
    }()

    
    //Test layout
    
    let separator: UIView = {
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
        textField.isUserInteractionEnabled = true
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = item?.itemTitle
        let height = (self.navigationController?.navigationBar.frame.height)!
        print(height)
        
        view.addSubview(image)
        let width = view.frame.width/1.5
        image.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 125, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: width)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        view.addSubview(changeImageButton)
        changeImageButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 0)
        changeImageButton.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        changeImageButton.centerYAnchor.constraint(equalTo: image.bottomAnchor).isActive = true

        setUpFields()
        
        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)

        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }

    
    func addSubviews() {
        
        view.addSubview(separator)
        view.addSubview(separator)
        
        view.addSubview(fullnameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        
        view.addSubview(descriptionLabel)
        view.addSubview(fullnameTextField)
        view.addSubview(usernameTextField)
        view.addSubview(bioTextField)
        view.addSubview(descriptionTextField)
        
    }

    
    func setUpFields() {
        addSubviews()
        separator.anchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        fullnameLabel.anchor(top: separator.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
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
        

    }
    
    
    
}
