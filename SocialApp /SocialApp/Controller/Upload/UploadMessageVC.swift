//
//  UploadMessageVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 12/12/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class UploadMessageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User? {
        didSet {
            guard let ownerUid = user?.uid else { return }
            Database.fetchUser(with: ownerUid) { (user) in
                if user.profileImageUrl == nil {
                    print("nil")
                    return
                } else {
                    self.profileImage.loadImage(with: user.profileImageUrl)
                    print(user.profileImageUrl!)
                }
            }
        }
    }
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        return image
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Message:"
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.font = label.font?.withSize(16)
        return label
    }()
    
    let descriptionTextView: UITextField = {
        let textView = UITextField()
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textView.layer.cornerRadius = 10
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.attributedPlaceholder = NSAttributedString(string: "Add Message",attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        textView.font = .systemFont(ofSize: 16)
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 0))
        textView.leftView = leftView
        textView.leftViewMode = .always
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Message"
        navigationController?.navigationBar.isTranslucent = false
        configureNavigationButton()
        configureLayout()
    }
    
    func configureLayout() {
        
        view.addSubview(profileImage)
        profileImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImage.layer.cornerRadius = 40
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        descriptionLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: profileImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 300)
    }
    
    func configureNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleBackTapped))
        let next =  UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handleNextTapped))
        navigationItem.rightBarButtonItems = [next]
    }

    @objc func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleNextTapped() {

    }

    @objc func handleCameraTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
