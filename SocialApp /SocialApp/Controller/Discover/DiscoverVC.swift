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


class DiscoverVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, DashboardShopDelegate {

    
    
    //MARK: - Properties
    var key: String?
    var posts = [Post]()


    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //register header
        collectionView!.register(DiscoverHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

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
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.post = posts[indexPath.item]
        return cell

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    //MARK: - Handler
    
    func handleViewStoreTapped(for cell: DiscoverStoreCell) {
        let viewStore = MyStore(collectionViewLayout: UICollectionViewFlowLayout())
        viewStore.store = cell.store
        navigationController!.pushViewController(viewStore, animated: true)
    }
    
    
    
    //MARK: - API

    func loadPosts() {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        if key == nil {
            USER_FEED_REF.child(currentUid).child("image-posts").queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
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
            USER_FEED_REF.child(currentUid).child("image-posts").queryOrderedByKey().queryEnding(atValue: self.key).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in

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

