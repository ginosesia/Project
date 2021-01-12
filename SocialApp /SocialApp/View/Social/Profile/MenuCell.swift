//
//  MenuCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 08/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit


class MenuCell: UICollectionViewCell {
    
    
    //MARK: - Properties
    
    lazy var postButton: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        //button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            postButton.textColor = isHighlighted ? Utilities.setThemeColor() : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            postButton.textColor = isSelected ? Utilities.setThemeColor() : UIColor.gray
            
        }
    }
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpView() {
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 0)
        
    }
}
