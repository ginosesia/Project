//
//  BasketCollectionView.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class BasketCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(BasketViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BasketViewCell
        cell?.item = items[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: 50))
        footerView.backgroundColor = .blue
        setUpFooter(footerView: footerView)
        return footerView
    }
    
    func setUpFooter(footerView: UIView) {
        
        var totalPrice = CGFloat(0)
        var totalNumber = 0
        
        for item in items {
            let myNumber = NumberFormatter().number(from: item.itemPrice)!
            totalPrice += CGFloat(truncating: myNumber)
            totalNumber += 1
        }
        
        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray2
            return view
        }()
        
        let total: UILabel = {
            let label = UILabel()
            label.text = "Total:  £ \(totalPrice)"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()
        
        let numberOfProducts: UILabel = {
            let label = UILabel()
            label.text = "Items: \(totalNumber)"
            label.font = UIFont.boldSystemFont(ofSize: 15)
            return label
        }()
        
        footerView.addSubview(separator)
        separator.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: footerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.8)
        footerView.addSubview(total)
        footerView.addSubview(numberOfProducts)
        numberOfProducts.anchor(top: nil, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        numberOfProducts.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        total.anchor(top: nil, left: nil, bottom: nil, right: footerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        total.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    }
}
