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
    
    var user: User?
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 10, bottom: 10, right: 20)
        textView.text = "What's happening?"
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = .none
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.rgb(red: 60, green: 60, blue: 60, alpha: 1).cgColor
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        navigationItem.title = "Message"
        navigationController?.navigationBar.isTranslucent = false
        configureNavigationButton()
        configureLayout()
    }
    
    func fetchUserData() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("Users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: userDictionary)
            self.user = user
            let image = user.profileImageUrl
            self.profileImage.loadImage(with: image!)
        })
    }
    

    
    
    func configureLayout() {
        
        view.addSubview(profileImage)
        view.addSubview(descriptionTextView)

        profileImage.anchor(top: descriptionTextView.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = 20
                
        descriptionTextView.anchor(top: view.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 200)
    }
    
    func configureNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleBackTapped))
        let next =  UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePostTapped))
        navigationItem.rightBarButtonItems = [next]
    }

    @objc func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handlePostTapped() {

        guard
            let caption = descriptionTextView.text,
            let currentUID = Auth.auth().currentUser?.uid else { return }
            let creationDate = Int(NSDate().timeIntervalSince1970)
    
                // post data
            let values = ["caption": caption,
                          "creationDate": creationDate,
                          "likes": 0,
                          "ownerUid": currentUID] as [String: Any]
            
            //post id
            let postId = POSTS_REF.childByAutoId()
            guard let postKey = postId.key else { return }
            
            //upload information to database
            postId.updateChildValues(values, withCompletionBlock: {(err, ref) in
                
            //update user post structure
                let userPostsRef = USER_POSTS_REF.child("message-post").child(currentUID)
            userPostsRef.updateChildValues([postKey: 1])
            
            //Update user feed structure
            self.updateUsersFeed(with: postKey)
            
            //return to home feed
            self.dismiss(animated: true, completion: {
                self.tabBarController?.selectedIndex = 0
            })
            
        })
    }
    
    func updateUsersFeed(with postId: String) {
        
        //current user id
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let values = [postId: 1]
        
        USER_FOLLOWER_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let followerUID = snapshot.key
            USER_FEED_REF.child(followerUID).updateChildValues(values)
        }
        
        //Update current user feed
        USER_FEED_REF.child(currentUid).updateChildValues(values)
                
    }


    @objc func handleCameraTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
