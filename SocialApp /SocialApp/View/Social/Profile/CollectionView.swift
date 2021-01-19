//
//  CollectionView.swift
//  SocialApp
//
//  Created by Gino Sesia on 11/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"
private let videoCell = "videoCell"
private let messageCell = "postMessageCell"


class CollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    //MARK: - Properties
    var posts = [Post]()
    var user: User?
    var key: String?
    let cellId = "cellId"
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoCell)
        self.collectionView.register(PostMessageCell.self, forCellWithReuseIdentifier: messageCell)

        
        collectionView.isPagingEnabled = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        fetchPosts()
        
        //refresh data
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UICollectionView
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        
        cell.backgroundColor = .systemPink
        
        if indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        } else if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: videoCell, for: indexPath) as! VideoCell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: messageCell, for: indexPath) as! PostMessageCell
        }
        //cell.post = posts[indexPath.item]
        //return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-4)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("hello")
    }
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.key = nil
        fetchPosts()
        collectionView.reloadData()
    }
    
    func refresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func fetchPosts() {
        
        var uid: String!
        
        if let user = self.user {
            uid = user.uid
        } else {
            uid = Auth.auth().currentUser?.uid
        }
        
        print("USER")
        
        // initial data pull
        if key == nil {
            
            USER_POSTS_REF.child(uid).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
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

            USER_POSTS_REF.child(uid).queryOrderedByKey().queryEnding(atValue: self.key).queryLimited(toLast: 7).observeSingleEvent(of: .value, with: { (snapshot) in

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
}
