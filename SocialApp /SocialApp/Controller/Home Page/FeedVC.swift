//
//  FeedVC.swift
//  Trial
//
//  Created by Gino Sesia on 26/05/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "Cell"
private let reuseIdentifierIndividual = "IndividualPostCell"

class FeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {
    
    //MARK: - Properties
    var delegate: HomeControllerDeligate?
    var users = [User]()
    var posts = [Post]()
    var viewSinglePost = false
    var viewFromProfile = false
    var post: Post?
    var key: String?
    let headerId = "headerId"
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImage: UIImageView?
    
    //MARK: - UICollectionViewFlowLayout
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width+100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if posts.count > 4 {
            if indexPath.item == posts.count - 1 {
                loadPosts()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        cell.backgroundColor = .systemGray6
        cell.post = posts[indexPath.item]
        handleUsernameLabelTapped(for: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    //MARK: - Handlers
    
    func handleUsernameLabelTapped(for cell: FeedCell) {
        
        guard let user = cell.post?.user else { return }
        guard let username = cell.post?.user?.username else { return }
        
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        cell.captionLabel.handleCustomTap(for: customType) { (_) in
            let userProfileController = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.user = user
            self.navigationController?.pushViewController(userProfileController, animated: true)
        }
    }
    
    
    func handleSeeLikesTapped(for header: FeedCell) {
        print("FeedVC: Line 90")
    }
    
    
//    @objc func handleRefresh() {
//        posts.removeAll(keepingCapacity: false)
//        self.key = nil
//        collectionView?.reloadData()
//    }
    
    func handleUsernameTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = post.user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func handleOptionsTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        guard let username = post.user?.username else { return }
        
        if post.ownerUid == Auth.auth().currentUser?.uid {
            let alertControllerCurrentUser = UIAlertController(title: username, message: nil, preferredStyle: .actionSheet)
            
            alertControllerCurrentUser.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                //Edit post
                let editPostCntroller = UploadPostVC()
                let navigationController = UINavigationController(rootViewController: editPostCntroller)
                editPostCntroller.post = post
                editPostCntroller.editMode = true
                self.present(navigationController, animated: true, completion: nil)
            }))
            
            alertControllerCurrentUser.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                post.removePost()
            }))
            
            alertControllerCurrentUser.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertControllerCurrentUser.view.tintColor = Utilities.setThemeColor()
            
            present(alertControllerCurrentUser, animated: true, completion: nil)
        } else {
            
            let alertController = UIAlertController(title: username, message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "View Profile", style: .default, handler: { (_) in
                guard let post = cell.post else { return }
                let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                userProfileVC.user = post.user
                self.navigationController?.pushViewController(userProfileVC, animated: true)
                
            }))
            alertController.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_) in
                print("Share: FeedVC Line 147")
            }))
            alertController.addAction(UIAlertAction(title: "Unfollow", style: .default, handler: { (_) in
                post.user?.unfollow()
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.view.tintColor = Utilities.setThemeColor()
            
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool) {
        guard let post = cell.post else { return }
        
        if post.didLike {
            // handle unlike post
            if !isDoubleTap {
                post.adjustLikes(addLike: false, completion: { (likes) in
                    cell.likeNumber.text = "\(likes)"
                    cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                    cell.likeButton.tintColor = .white
                })
            }
        } else {
            // handle like post
            post.adjustLikes(addLike: true, completion: { (likes) in
                cell.likeNumber.text = "\(likes)"
                cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                cell.likeButton.tintColor = .systemRed
            })
        }
    }
    
    func handleConfigureLikeButton(for cell: FeedCell) {
        guard let post = cell.post else { return }
        guard let postId = post.postId else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_LIKES_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            // check if post id exists in user-like structure
            if snapshot.hasChild(postId) {
                post.didLike = true
                cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                cell.likeButton.tintColor = .systemRed
            } else {
                post.didLike = false
                cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                cell.likeButton.tintColor = .white
            }
        }
    }
    
    func handleShowLikes(for cell: FeedCell) {
        print("working")
        guard let post = cell.post else { return }
        guard let postId = post.postId else { return }
        let followLikeVC = FollowLikeVC()
        followLikeVC.viewingMode = FollowLikeVC.ViewingMode(index: 2)
        followLikeVC.postID = postId
        navigationController?.pushViewController(followLikeVC, animated: true)
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    func handleShareButtonTapped(for cell: FeedCell) {
        print("Share Tapped (FeedVC: line 135)")
    }
    
    
    func handleMessagesTapped(for cell: FeedCell) {
        let messageController = MessagesController()
        navigationController?.pushViewController(messageController, animated: true)
    }
    
    func handleImageTapped(for cell: FeedCell) {
        let image = cell.postImage
        self.startingImage = image
        self.startingImage?.isHidden = true
        startingFrame = image.superview?.convert(image.frame, to: nil)
                
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = image.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.8)
                keyWindow.addSubview(self.blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                
                self.blackBackgroundView?.alpha = 1
                let height = zoomingImageView.frame.height
                let width = zoomingImageView.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                zoomingImageView.center = keyWindow.center

            } completion: { (completed) in
                //do nothing
            }
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            
            zoomOutImageView.layer.cornerRadius = 15
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0

            } completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImage?.isHidden = false
            }
        }
    }
    
    
    @objc func handleShowMessages() {
        let messagesController = MessagesController()
        navigationController?.pushViewController(messagesController, animated: true)
    }
    
    @objc func handleMenuToggle() {
        print("Menu")
    }
    
    @objc func handleCancelTapped() {
        self.dismiss(animated: true)
    }

    //MARK: - API
    func loadPosts() {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        if key == nil {
            USER_FEED_REF.child(currentUid).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }

                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    self.fetchPost(with: postId)
                })
                self.key = first.key
            })
        } else {
            USER_FEED_REF.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.key).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in

                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }

                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.key {
                        self.fetchPost(with: postId)
                    }
                })
                self.key = first.key
            })
        }
    }
    
    func fetchPost(with postId: String) {

        Database.fetchPost(with: postId) { (post) in
            self.posts.append(post)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView.reloadData()
        }
    }


    func updateUserFeed() {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let followingUID = snapshot.key

            USER_POSTS_REF.child(followingUID).observe(.childAdded, with: { (snapshot) in
                let postID = snapshot.key
                USER_FEED_REF.child(currentUid).updateChildValues([postID: 1])
            })
        }

        USER_POSTS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            print(snapshot)
            USER_FEED_REF.child(currentUid).updateChildValues([postID: 1])
        }
    }
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        loadPosts()
        updateUserFeed()
    }
}
