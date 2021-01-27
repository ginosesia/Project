//
//  EditStoreItem.swift
//  SocialApp
//
//  Created by Gino Sesia on 26/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class EditStoreItem: UIViewController {
    
    //MARK: - Properties
    
    var item: Item? {
        didSet {
            guard let imageUrl = item?.imageUrl else { return }
            navigationController?.title = item?.itemTitle
            image.loadImage(with: imageUrl)
        }
    }
    
    let image: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .systemGreen
        return image
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = item?.itemTitle
        let height = (self.navigationController?.navigationBar.frame.height)!
        print(height)
        
        view.addSubview(image)
        image.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 90, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width)
        
    }
    
    
    
}
