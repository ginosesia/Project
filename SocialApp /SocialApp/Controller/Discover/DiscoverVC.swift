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
    

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //register header
        collectionView!.register(StoreHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)


    }
    
    //MARK: - Header
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 150)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! StoreHeader
            header.backgroundColor = .systemPink
            return header
    }

    
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width)
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.backgroundColor = .systemTeal
        return cell

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
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

