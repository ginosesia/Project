//
//  ChatController.swift
//  SocialApp
//
//  Created by Gino Sesia on 14/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Firebase
private let reuseIdentifier = "ChatCell"

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ChatCellSettingsDelegate {
   
    
    
    //MARK: - Properties
    
    var user: User?
    var messages = [Message]()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        containerView.addSubview(messageTextField)
        containerView.addSubview(sendButton)
        containerView.backgroundColor = .black
        
        messageTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 16, paddingRight: 5, width: 0, height: 0)
        sendButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 50, height: 0)
        sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor).isActive = true
        
        let separatorView: UIView = {
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor.gray
            containerView.addSubview(separatorView)
            separatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
            return separatorView
        }()
        
        return containerView
    }()
    

    let messageTextField: UITextField = {
        let textField = UITextField()
        let name = "Enter message..."
        textField.attributedPlaceholder = NSAttributedString(string: name,attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.leftViewMode = .always
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 0))
        textField.leftView = leftView
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - API
    
    func uploadMessage() {
        
        guard let messageText = messageTextField.text else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        guard let uid = user.uid else { return }
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        if messageText != "" {
            let values: [String: AnyObject] = ["toId": user.uid as AnyObject,
                                               "fromId": currentUid as AnyObject,
                                               "creationDate": creationDate as AnyObject,
                                               "messageText": messageText as AnyObject]
            
            
            let messageRef = MESSAGES_REF.childByAutoId()
            
            guard let messageKey = messageRef.key else { return }
            
            messageRef.updateChildValues(values) { (err, ref) in
                USER_MESSAGES_REF.child(currentUid).child(uid).updateChildValues([messageKey: 1])
                USER_MESSAGES_REF.child(uid).child(currentUid).updateChildValues([messageKey: 1])
            }
        } else { return }
    }
    
    
    func observeMessages() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let chatPartnerId = self.user?.uid else { return }
        
        USER_MESSAGES_REF.child(currentUid).child(chatPartnerId).observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            self.fetchMessage(withMessageId: messageId)
            
        }
    }
    
    func fetchMessage(withMessageId messageId: String) {
        
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView?.reloadData()
        }
    }
    
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureNavBar()
        
        observeMessages()
        
        let dismissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyBoard)

    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    //MARK: - UICollection View
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: CGFloat = 80
        let message = messages[indexPath.row]
        height = estimateFrame(message.messageText).height + 20
        
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        let index = messages[indexPath.row]
        cell.message = index
        configureMessage(cell: cell, message: index)
        return cell
    }
    
    //MARK: - Handlers
    
    @objc func handleOptionsTapped(for cell: ChatCell) {
        print("hi")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.init(red: 0/255, green: 171/255, blue: 154/255, alpha: 0.5)
        alertController.view.tintColor = Utilities.setThemeColor()
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)

    }
    
    
    func configureNavBar() {
        guard let user = self.user else { return }
        
        navigationItem.title = user.username
    }
    
    func estimateFrame(_ text: String) -> CGRect {
        let size = CGSize(width: 250, height: 100)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil)
    }
  
    
    
    func configureMessage(cell: ChatCell, message: Message) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        cell.bubbleWidthAnchor?.constant = estimateFrame(message.messageText).width + 30
        cell.frame.size.height = estimateFrame(message.messageText).height + 20
    
        if message.fromId == currentUid {
            //Message from current user
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.bubbleView.layer.borderWidth = 1.6
//            let blue = UIColor.rgb(red: 0, green: 191, blue: 255, alpha: 1)
//            let green = UIColor.rgb(red: 91, green: 184, blue: 153, alpha: 1)
            cell.bubbleView.layer.borderColor = UIColor.rgb(red: 91, green: 184, blue: 153, alpha: 0.8).cgColor
            cell.bubbleView.backgroundColor = Utilities.setThemeColor()
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            
            
        } else {
            //Message from other user
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1)
            cell.bubbleView.layer.borderWidth = 1.6
            cell.bubbleView.layer.borderColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1).cgColor
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = false
            

        }
    }
     
    @objc func sendMessage() {
        uploadMessage()
        messageTextField.text = nil
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false

    }
    
}
