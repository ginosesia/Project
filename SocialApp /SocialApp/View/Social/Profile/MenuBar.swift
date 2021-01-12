//
//  MenuBar.swift
//  SocialApp
//
//  Created by Gino Sesia on 08/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    //MARK: - Properties
    var horizontalBarLeftAnchor: NSLayoutConstraint?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    let cellId = "cellID"
    let menuBarTitle = ["Pictures", "Videos", "Posts"]
    var homeController: SelectPostVC?
    var homeControllerProfile: UserProfileVC?

    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHorizontalBar()
        //Register CollectionView
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)

        //Add Collection View
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 0)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        
    }
    
    
    func setHorizontalBar() {
        
        let horizontalBar = UIView()
        horizontalBar.backgroundColor = Utilities.setThemeColor()
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBar)
        
        horizontalBarLeftAnchor = horizontalBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchor?.isActive = true
        
        horizontalBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        horizontalBar.layer.cornerRadius = 1.5
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        let x = CGFloat(indexPath.item) * frame.width/3
        horizontalBarLeftAnchor?.constant = x
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item+1)
        print(indexPath.item)
    
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        let name = menuBarTitle[indexPath.item]
        
        cell.postButton.text = name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
