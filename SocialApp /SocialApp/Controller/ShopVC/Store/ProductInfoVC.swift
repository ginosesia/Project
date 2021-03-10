//
//  ProductInfoVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 09/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProductInfoVC: UIViewController {
    
    var item: Item? {
        didSet {
            guard let title = item?.itemTitle else { return}
            guard let description = item?.itemDescription else { return}
            guard let imageURL = item?.imageUrl else { return }
            guard let price = item?.itemPrice else { return }
            guard let quantity = item?.itemStock else { return }

            navigationItem.title = title
            itemPrice.text = "£ \(price)"
            itemTitle.text = title
            image.loadImage(with: imageURL)
            aboutProduct.text = description
            stock.text = "\(quantity) Left"
            
            guard let uid = item?.uid else { return }
            if uid == Auth.auth().currentUser?.uid {
                add.isEnabled = false
            }
        }
    }
    
    let itemPrice: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let about: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.text = "About:"
        return lb
    }()
    
    let aboutProduct: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.numberOfLines = 0
        return lb
    }()

    let stock: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()


    let add: UIButton = {
        let button = UIButton()
        button.backgroundColor = Utilities.setThemeColor()
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddTapped), for: .touchUpInside)
        return button
    }()
    
    let itemTitle: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 25)
        return lb
    }()

    let image: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let separator: UIView = {
        let sp = UIView()
        sp.backgroundColor = .systemGray4
        return sp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        setNavBar()
        setLayout()
    }
    
    func setNavBar() {
        
        navigationController?.navigationBar.barTintColor = .black
    }
    
    func setLayout() {
        view.addSubview(image)
        image.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
                
        view.addSubview(itemTitle)
        itemTitle.anchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
   
        view.addSubview(itemPrice)
        itemPrice.anchor(top: itemTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
       
        let height = CGFloat(35)
        view.addSubview(add)
        add.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: height, height: height)
        add.centerYAnchor.constraint(equalTo: itemTitle.centerYAnchor).isActive = true
        add.layer.cornerRadius = height/2
        
        view.addSubview(separator)
        separator.anchor(top: itemPrice.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 1)
        
        view.addSubview(stock)
        stock.anchor(top: separator.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)

        view.addSubview(about)
        about.anchor(top: separator.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        view.addSubview(aboutProduct)
        aboutProduct.anchor(top: about.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)

    }
    
    //MARK: - Handlers
    
    @objc func handleAddTapped() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["title": item!.itemTitle!,
                      "price": item!.itemPrice!,
                      "imageUrl": item!.imageUrl!] as [String: Any]

        USER_BAG_REF.child(uid).child((item?.itemId)!).setValue(values)
    }
}
