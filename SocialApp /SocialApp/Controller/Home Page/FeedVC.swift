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
    var userProfileController: CollectionView?
    let headerId = "headerId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - UICollectionViewFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        header.layer.borderColor = Utilities.setThemeColor().cgColor
        header.layer.borderWidth = 3
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    
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
        if viewSinglePost {
            return 1
        } else {
            return posts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self

        if viewSinglePost {
            if let post = self.post {
                cell.post = post
            }
        } else {
            cell.post = posts[indexPath.item]
        }
        
        handleHastagTapped(for: cell)
        handleMentionTapped(for: cell)
        handleUsernameLabelTapped(for: cell)
        
        cell.backgroundColor = UIColor.rgb(red: 20, green: 20, blue: 20, alpha: 1)
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !viewSinglePost {
            let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
            feedVC.viewSinglePost = true
            feedVC.post = posts[indexPath.item]
            present(feedVC, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - Handlers
    
    func handleHastagTapped(for cell: FeedCell) {
        
        cell.captionLabel.handleHashtagTap { (hashtag) in
            let controller = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.hashtag = hashtag
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
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
    
    
    func handleMentionTapped(for cell: FeedCell) {
        cell.captionLabel.handleMentionTap { (username) in
            self.getMention(with: username)
        }
        
    }
    
    func handleSeeLikesTapped(for header: FeedCell) {
        print("FeedVC: Line 90")
    }
    
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.key = nil
        loadPosts()
        collectionView?.reloadData()
    }
    
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
            alertControllerCurrentUser.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                post.removePost()
                
                //Delete post
                if !self.viewSinglePost {
                    self.handleRefresh()
                } else {
                    if let userProfileController = self.userProfileController {
                        _ = self.navigationController?.popViewController(animated: true)
                        userProfileController.handleRefresh()
                    }
                }
            }))
            
            alertControllerCurrentUser.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                
                //Edit post
                let editPostCntroller = UploadPostVC()
                let navigationController = UINavigationController(rootViewController: editPostCntroller)
                editPostCntroller.post = post
                editPostCntroller.editMode = true
                self.present(navigationController, animated: true, completion: nil)
                
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
            alertController.addAction(UIAlertAction(title: "Turn On Post Notifications", style: .default, handler: { (_) in
                print("Notifications: FeedVC Line 150")
            }))
            alertController.addAction(UIAlertAction(title: "Mute", style: .default, handler: { (_) in
                print("Mute: FeedVC Line 153")
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
                    cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)

                })
            }
        } else {
            // handle like post
            post.adjustLikes(addLike: true, completion: { (likes) in
                cell.likeNumber.text = "\(likes)"
                cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
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
            } else {
                post.didLike = false
                cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
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
        
        
        if viewSinglePost {
            
            self.dismiss(animated: true, completion: nil)
            navigationController?.pushViewController(commentVC, animated: true)
            
        } else {
            navigationController?.pushViewController(commentVC, animated: true)
            
        }
    }
    
    
    func handleShareButtonTapped(for cell: FeedCell) {
        print("Share Tapped (FeedVC: line 135)")
    }
    
    
    func handleMessagesTapped(for cell: FeedCell) {
        let messageController = MessagesController()
        navigationController?.pushViewController(messageController, animated: true)
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImage: UIImageView?
    
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
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(self.blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                
                self.blackBackgroundView?.alpha = 1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
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
   
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
   
    
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
        
        Database.fetchPost(with: postId, completion: { (post) in
            self.posts.append(post)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView.reloadData()
        })
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
            
            USER_FEED_REF.child(currentUid).updateChildValues([postID: 1])
        }
        
    }
    
    //MARK: - Init
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        //        let layout = UICollectionViewFlowLayout()
        //        layout.scrollDirection = .vertical
        //
        //        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        //        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collectionView?.isPagingEnabled = true
        //        collectionView.dataSource = self
        
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        if !viewSinglePost {
            loadPosts()
            //Configure Refresh feed
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = .white
            refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            collectionView?.refreshControl = refreshControl
        }
        updateUserFeed()
        
    }
    
    
}

