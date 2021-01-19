//
//  HeaderCell.swift
//  SocialApp
//
//  Created by Gino Sesia on 18/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit


class HeaderCell: BaseCell {
    
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Options"
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
        return view
    }()

    override func setupViews() {

        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(separator)
        separator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }

}
