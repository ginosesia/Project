//
//  CommentVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 02/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentCell"


class CommentVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccesoryViewDelegate {
    
    //MARK: - Properties
    var comments = [Comment]()
    var post: Post?
    
    lazy var containerView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let containerView = CommentInputAccesoryView(frame:frame)
        containerView.backgroundColor = .green
        containerView.delegate = self
        return containerView
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        fetchComments()
        
        navigationController?.navigationBar.tintColor = Utilities.setThemeColor()
        navigationController?.navigationBar.isHidden = false
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //Handle refresh pulled down
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl

    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tabBarController?.tabBar.isHidden = true
    }
       
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       tabBarController?.tabBar.isHidden = false
    }

    override var inputAccessoryView: UIView? {
       get {
           return containerView
       }
    }

    override var canBecomeFirstResponder: Bool {
       return true
}
    
    //MARK: - UICollection View
    
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
            
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetsize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetsize)
        
        let height = max(45 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfComments = comments.count
        return numberOfComments
    }
    
    //MARK: - Handlers
    
    
    @objc func handleRefresh() {
        comments.removeAll(keepingCapacity: false)
        fetchComments()
        collectionView?.reloadData()
    }

    
    //MARK: - API

    func fetchComments() {
        
        guard let postId = self.post?.postId else { return }
        
        COMMENT_REF.child(postId).observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dictionary["Uid"] as? String else { return }

            Database.fetchUser(with: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView?.reloadData()
            })
        }
    }
    
    func uploadCommentNotification() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let postId = self.post?.postId else { return }
        guard let uid = post?.user?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "uid": currentUid,
                      "type": COMMENT_INT_VALUE,
                      "postId": postId] as [String : Any]

        //Upload comment notification to database
        
        if uid != currentUid {
            NOTIFICATIONS_REF.child(uid).childByAutoId().updateChildValues(values)
        }
    }
    
    func didSubmit(for comment: String) {

        guard let postId = self.post?.postId else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)

        let values = ["commentText": comment,
                      "creationDate": creationDate,
                      "uid": uid] as [String : Any]

        COMMENT_REF.child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            self.uploadCommentNotification()

            if comment.contains("@") {
                self.uploadNotification(for: postId, with: comment, isForComment: true)
            }

            self.containerView.clearCommentTextView()

        }
    }
}
