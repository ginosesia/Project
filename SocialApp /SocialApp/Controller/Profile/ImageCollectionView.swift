//
//  ImageCollectionView.swift
//  SocialApp
//
//  Created by Gino Sesia on 19/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class ImageCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(SelectPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width

        return CGSize(width: width, height: width)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectPostCell

    }



}
