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


class DiscoverVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
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
}
