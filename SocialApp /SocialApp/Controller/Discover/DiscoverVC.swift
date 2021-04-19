//
//  DiscoverVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 13/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "StoreHeader"


class DiscoverVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
        
    
    //MARK: - Properties
    var key: String?
    var posts = [Post]()


    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //register header
        collectionView!.register(DiscoverHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        navigationController?.navigationBar.isHidden = true
        
        loadPosts()
    }
    
    //MARK: - Header
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width/1.75)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! DiscoverHeader
        return header
    }
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width)
        return CGSize(width: width, height: width+100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.post = posts[indexPath.item]
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
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
    
    
    
    

    //MARK: - API

    func loadPosts() {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        if key == nil {
            USER_DISCOVER_FEED_REF.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
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
            USER_DISCOVER_FEED_REF.queryOrderedByKey().queryEnding(atValue: self.key).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in

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


}


//func handleVideoTapped(for cell: FeedCell) {
//    let image = cell.postImage
//    self.startingImage = image
//    self.startingImage?.isHidden = true
//    startingFrame = image.superview?.convert(image.frame, to: nil)
//            
//    let zoomingImageView = UIImageView(frame: startingFrame!)
//    zoomingImageView.image = image.image
//    zoomingImageView.isUserInteractionEnabled = true
//    zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
//    
//    
//    if let keyWindow = UIApplication.shared.keyWindow {
//        
//        blackBackgroundView = UIView(frame: keyWindow.frame)
//        blackBackgroundView?.backgroundColor = UIColor.black
//        blackBackgroundView?.alpha = 0
//        keyWindow.addSubview(self.blackBackgroundView!)
//        keyWindow.addSubview(zoomingImageView)
//        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
//            
//            self.blackBackgroundView?.alpha = 1
//            let height = zoomingImageView.frame.height
//            let width = zoomingImageView.frame.width
//            zoomingImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
//            zoomingImageView.center = keyWindow.center
//
//        } completion: { (completed) in
//            //do nothing
//        }
//    }
//}

    
    
//
//    func fetchPosts() {
//
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        if key == nil {
//            POSTS_REF.child(currentUid).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                self.tableView.refreshControl?.endRefreshing()
//
//                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
//                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
//
//                allObjects.forEach({ (snapshot) in
//                    let postId = snapshot.key
//                    self.fetchPost(with: postId)
//                })
//                self.key = first.key
//            })
//        } else {
//            POSTS_REF.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.key).queryLimited(toLast: 11).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
//                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
//
//                allObjects.forEach({ (snapshot) in
//                    let postId = snapshot.key
//                    if postId != self.key {
//                        self.fetchPost(with: postId)
//                    }
//                })
//                self.key = first.key
//            })
//        }
//    }
//
//
//    func fetchPost(with postId: String) {
//
//        Database.fetchPost(with: postId, completion: { (post) in
//            self.posts.append(post)
//            self.posts.sort(by: { (post1, post2) -> Bool in
//                return post1.creationDate > post2.creationDate
//            })
//            self.collectionView.reloadData()
//        })
//    }

