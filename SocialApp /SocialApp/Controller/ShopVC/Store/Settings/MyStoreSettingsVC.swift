//
//  MyStoreSettingsVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 31/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyStoreSettingsVC: UIViewController {
    
    //MARK: - Properties
    var store: Store?
    var descriptionChanged = false
    var bankNameChanged = false
    var cardNoChanged = false
    var securityCodeChanged = false
    
    var updatedDescription: String?
    var updatedCardNo: String?
    var updatedBankName: String?
    var updatedSecurityCode: String?

    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
        
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
        return view
    }()
    
    let separatorBank: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
        return view
    }()
    
    
    let storenameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        Utilities.styleTextField(textField, name: "")
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let storeIdTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.textColor = .white
        Utilities.styleTextField(textField, name: "")
        textField.font = UIFont.systemFont(ofSize: 11)
        textField.isUserInteractionEnabled = false
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
    
    let storeInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "STORE"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    let bankInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "BANK"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    
    let storenameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
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
    
    let storeIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Store ID"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let bankLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let bankTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.textColor = .white
        Utilities.styleTextField(textField, name: "")
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    let cardLabel: UILabel = {
        let label = UILabel()
        label.text = "Card No"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let cardTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.textColor = .white
        Utilities.styleTextField(textField, name: "")
        textField.isUserInteractionEnabled = true
        textField.isSecureTextEntry = true
        return textField
    }()

    let cLabel: UILabel = {
        let label = UILabel()
        label.text = "Security Code"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Utilities.setThemeColor()
        return label
    }()
    
    let cTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.textColor = .white
        Utilities.styleTextField(textField, name: "")
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    lazy var unlock: UIButton = {
        let button = UIButton()
        button.tintColor = Utilities.setThemeColor()
        button.addTarget(self, action: #selector(showDetailsTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 0.6)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitle("Show Details", for: .normal)
        return button
    }()
    
    @objc func showDetailsTapped() {
        
        if cTextField.isSecureTextEntry == true && cardTextField.isSecureTextEntry == true {
            cTextField.isSecureTextEntry = false
            cardTextField.isSecureTextEntry = false
            unlock.setTitle("Hide Details", for: .normal)
        }
        
        if cTextField.isSecureTextEntry == false && cardTextField.isSecureTextEntry == false {
            cTextField.isSecureTextEntry = true
            cardTextField.isSecureTextEntry = true
            unlock.setTitle("Show Details", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
        addSubviews(container: view)
        configureViewComponents()

        descriptionTextField.delegate = self
        bankTextField.delegate = self
        cTextField.delegate = self
        cardTextField.delegate = self
        
        storenameTextField.text = store?.storeName
        guard let imageUrl = store?.storeImageUrl else { return }
        profileImage.loadImage(with: imageUrl)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        storeIdTextField.text = uid
        descriptionTextField.text = store?.description
        cTextField.text = store?.securityCode
        bankTextField.text = store?.bankName
        cardTextField.text = store?.cardNumber

        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)

    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
        
    func setUpNavBar() {
        navigationItem.title = "Settings"
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    @objc func handleSaveTapped() {
        view.endEditing(true)
        if descriptionChanged {
            updateDescription()
        }
        
        if cardNoChanged {
            updateCardNo()
        }
        
        if securityCodeChanged {
            updateSecurityNo()
        }
        
        if bankNameChanged {
            updateBankName()
        }
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    func updateDescription() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let updatedDescription = self.updatedDescription else { return }
        
        guard descriptionChanged == true else { return }
        
        STORE_REF.child(currentUid).child("description").setValue(updatedDescription) { (err, ref) in
            
        }
        
    }
    
    func updateCardNo() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let updatedCardNo = self.updatedCardNo else { return }
        
        guard cardNoChanged == true else { return }
        
        STORE_REF.child(currentUid).child("cardNumber").setValue(updatedCardNo) { (err, ref) in
            
        }
    }
    
    func updateSecurityNo() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let updatedSecurityNo = self.updatedSecurityCode else { return }
        
        guard securityCodeChanged == true else { return }
        
        STORE_REF.child(currentUid).child("securityCode").setValue(updatedSecurityNo) { (err, ref) in
            
        }
    }
    
    
    func updateBankName() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let updatedBankName = self.updatedBankName else { return }
        
        guard bankNameChanged == true else { return }
        
        STORE_REF.child(currentUid).child("bankName").setValue(updatedBankName) { (err, ref) in
            
        }
    }
    
    func configureViewComponents() {
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 180)

        let container = UIView(frame: frame)
        view.addSubview(container)
        
        addSubviews(container: container)
        
        let height = CGFloat(120)
        
        profileImage.anchor(top: container.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: height, height: height)
        profileImage.layer.cornerRadius = height/2
        //center image
        profileImage.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true

        
        separator.anchor(top: nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 1)
        
        storeInfoLabel.anchor(top: separator.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        storenameLabel.anchor(top: storeInfoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        descriptionLabel.anchor(top: storenameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        storeIdLabel.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        
        storenameTextField.anchor(top: nil, left: storenameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        storenameTextField.layer.cornerRadius = 6
        storenameTextField.centerYAnchor.constraint(equalTo: storenameLabel.centerYAnchor).isActive = true
        
        descriptionTextField.anchor(top: nil, left: descriptionLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        descriptionTextField.layer.cornerRadius = 6
        descriptionTextField.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor).isActive = true
        
        storeIdTextField.anchor(top: nil, left: storeIdLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        storeIdTextField.layer.cornerRadius = 6
        storeIdTextField.centerYAnchor.constraint(equalTo: storeIdLabel.centerYAnchor).isActive = true

        separatorBank.anchor(top: storeIdTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        bankInfoLabel.anchor(top: separatorBank.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        bankLabel.anchor(top: bankInfoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)

        bankTextField.anchor(top: nil, left: bankLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        bankTextField.layer.cornerRadius = 6
        bankTextField.centerYAnchor.constraint(equalTo: bankLabel.centerYAnchor).isActive = true

        cardLabel.anchor(top: bankLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)

        cardTextField.anchor(top: nil, left: cardLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 1.6, height: 32)
        cardTextField.layer.cornerRadius = 6
        cardTextField.centerYAnchor.constraint(equalTo: cardLabel.centerYAnchor).isActive = true

        cLabel.anchor(top: cardLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)

        cTextField.anchor(top: nil, left: cLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: view.frame.width / 3, height: 32)
        cTextField.layer.cornerRadius = 6
        cTextField.centerYAnchor.constraint(equalTo: cLabel.centerYAnchor).isActive = true
        
        unlock.anchor(top: cTextField.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 110, height: 0)

    }
    
    func addSubviews(container: UIView) {
        
        container.addSubview(profileImage)
        container.addSubview(separator)
        
        view.addSubview(storenameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(storeIdLabel)
        view.addSubview(cardLabel)
        view.addSubview(bankLabel)
        view.addSubview(separatorBank)
        view.addSubview(cLabel)
        view.addSubview(bankInfoLabel)
        view.addSubview(storeInfoLabel)
        view.addSubview(unlock)

        view.addSubview(descriptionLabel)
        view.addSubview(storenameTextField)
        view.addSubview(storeIdTextField)
        view.addSubview(cardTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(bankTextField)
        view.addSubview(cTextField)

    }
}



extension MyStoreSettingsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        let trimmedDescriotion = descriptionTextField.text?.replacingOccurrences(of: "//s+$", with: "",options: .regularExpression)
        let trimmedcardNo = cardTextField.text?.replacingOccurrences(of: "//s+$", with: "",options: .regularExpression)
        let trimmedsecurity = cTextField.text?.replacingOccurrences(of: "//s+$", with: "",options: .regularExpression)
        let trimmedBankName = bankTextField.text?.replacingOccurrences(of: "//s+$", with: "",options: .regularExpression)

        guard store?.description != trimmedDescriotion else {
            print("description not changed")
            descriptionChanged = false
            return
        }
        
        guard store?.cardNumber != trimmedcardNo else {
            print("card number not changed")
            cardNoChanged = false
            return
        }

        guard store?.securityCode != trimmedsecurity else {
            print("card number not changed")
            securityCodeChanged = false
            return
        }

        guard store?.bankName != trimmedBankName else {
            print("card number not changed")
            bankNameChanged = false
            return
        }
    
        updatedSecurityCode = trimmedsecurity?.lowercased()
        securityCodeChanged = true

        updatedCardNo = trimmedcardNo?.lowercased()
        cardNoChanged = true

        updatedDescription = trimmedDescriotion?.lowercased()
        descriptionChanged = true

        updatedBankName = trimmedBankName?.lowercased()
        bankNameChanged = true
    }
}
