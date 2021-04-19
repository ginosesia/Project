//
//  UploadPostVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

class UploadPostVC: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    
    var selectedImage: UIImage?
    var post: Post?
    var editMode = false
    
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Description:"
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.font = label.font?.withSize(14)
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textView.layer.cornerRadius = 10
        textView.textColor = UIColor(white: 1, alpha: 0.5)
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 20)
        return textView
    }()
    
    let activity: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()

    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        loadImage()
        view.backgroundColor = .black
        //text view delegate
        descriptionTextView.delegate = self
        
        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if editMode {
            guard let post = self.post else { return }
            photoImageView.loadImage(with: post.imageUrl)
            descriptionTextView.text = post.caption
            configureNavigationBar(editMode: true)
        } else {
            configureNavigationBar(editMode: false)
        }
    }
    
    func configureNavigationBar(editMode: Bool) {
        if !editMode {
            navigationItem.title = "Post Details"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(uploadPostToDatabase))

                    } else {
            navigationItem.title = "Edit Post"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelTapped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
        }
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
    
    //MARK: - UITextField
    
    @objc func saveChanges() {
        
        guard let post = self.post else { return }
        let updatedCaption = descriptionTextView.text
                
        POSTS_REF.child(post.postId).child("caption").setValue(updatedCaption) { (err, ref) in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func uploadPostToDatabase() {
        
        if !editMode {
            guard
                let caption = descriptionTextView.text,
                let postImg = photoImageView.image,
                let currentUID = Auth.auth().currentUser?.uid else { return }
            
            //image upload gata
            guard let uploadData = postImg.jpegData(compressionQuality: 0.3) else { return }
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
                    let values = ["caption": caption,
                                  "creationDate": creationDate,
                                  "likes": 0,
                                  "imageUrl": imageUrl,
                                  "ownerUid": currentUID] as [String: Any]
                    
                    //post id
                    let postId = POSTS_REF.childByAutoId()
                    guard let postKey = postId.key else { return }
                    
                    //upload information to database
                    USER_DISCOVER_FEED_REF.updateChildValues([postKey: 1])
                    
                    postId.updateChildValues(values, withCompletionBlock: {(err, ref) in
                        
                        //update user post structure
                        let userPostsRef = USER_POSTS_REF.child(currentUID)
                        userPostsRef.updateChildValues([postKey: 1])
                        
                        //Update user feed structure
                        self.updateUsersFeed(with: postKey)
                        
                        //return to home feed
                        self.dismiss(animated: true, completion: {
                            self.tabBarController?.selectedIndex = 0
                        })
                        
                    })
                })
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                self.view.addSubview(self.activity)
                self.activity.anchor(top: self.photoImageView.topAnchor, left: self.photoImageView.leftAnchor, bottom: nil, right: self.photoImageView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                self.activity.centerXAnchor.constraint(equalTo: self.photoImageView.centerXAnchor).isActive = true
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }

        } else {
            saveChanges()
        }
    }
        
    
    func configureLayout() {
        var paddingTop: CGFloat = 80
        
        if !editMode {
            paddingTop = 30
        } else {
            paddingTop = 80
        }
        
            view.addSubview(photoImageView)
            photoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: paddingTop, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width/2, height: view.frame.width/2)
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            photoImageView.layer.cornerRadius = 15
            view.addSubview(descriptionLabel)
            descriptionLabel.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 12, width: 0, height: 20)
            view.addSubview(descriptionTextView)
            descriptionTextView.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        photoImageView.image = selectedImage
    }
    
    
    @objc func handleCancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    

    //MARK: - API
}
