//
//  CommentInputTextView.swift
//  SocialApp
//
//  Created by Gino Sesia on 03/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    //MARK: = Prperties
    
    let commentLabelPlaceHolder: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment..."
        label.textColor = .gray
        
        return label
    }()
    
    //MARK: - Handlers
    
    @objc func handleInputTextChanged() {
        commentLabelPlaceHolder.isHidden = !self.text.isEmpty
    }
    
    
    
    //MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInputTextChanged), name: UITextView.textDidChangeNotification, object: nil)

        addSubview(commentLabelPlaceHolder)
        commentLabelPlaceHolder.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
