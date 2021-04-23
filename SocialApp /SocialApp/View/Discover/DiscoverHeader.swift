//
//  DiscoverHeader.swift
//  SocialApp
//
//  Created by Gino Sesia on 28/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class DiscoverHeader: UICollectionViewCell {
    
    //MARK: - Properties
    let collectionView: DiscoverCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = DiscoverCollection(collectionViewLayout: layout)
        return view
    }()
    
    let itemCollection: ItemCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = ItemCollection(collectionViewLayout: layout)
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView.view)
        collectionView.view.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        addSubview(itemCollection.view)
        itemCollection.view.backgroundColor = .systemTeal
        itemCollection.view.anchor(top: collectionView.view.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
