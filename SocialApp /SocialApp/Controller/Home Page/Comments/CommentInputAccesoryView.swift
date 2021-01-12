//
//  CommentInputAccesoryView.swift
//  SocialApp
//
//  Created by Gino Sesia on 03/10/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

class CommentInputAccesoryView: UIView {


    //MARK: - Properties
    var delegate: CommentInputAccesoryViewDelegate?
    
    let commentTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        return textView
    }()

    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.gray
        return separatorView
    }()
        
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 50, height: 50)

        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 5, paddingRight: 10, width: 0, height: 20)
        
        postButton.centerYAnchor.constraint(equalTo: commentTextView.centerYAnchor).isActive = true

        addSubview(separatorView)
        separatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func clearCommentTextView() {
        commentTextView.commentLabelPlaceHolder.isHidden = false
        commentTextView.text = nil
    }
    
    
    
    //MARK: - Handlers
    
    @objc func postComment() {
        
        guard let comment = commentTextView.text else { return }
        
        delegate?.didSubmit(for: comment)
        
    }
    
}
