//
//  ChatViewController.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/27.
//

import UIKit
import MessageKit
import FirebaseAuth

struct Message: MessageType {
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var sender: SenderType
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: "Strin", senderId: "1", displayName: "Joe Biden")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(messageId: "1", sentDate: Date(), kind: .text("hello joe"), sender: selfSender))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        prepareViews()
        prepareNavigationBar()
        
    }
    
   
    
    
    //log out user from the chat room
    @objc func logoutButtonTapped() {
        guard let storyboard = self.storyboard else {
            return
        }
        do {
            try FirebaseAuth.Auth.auth().signOut()
            ViewControllerManager.gotToViewController(from: self, to: Controller.PopRootViewController, storyboard: storyboard)
            print("Log out user")
        }catch {
            print("Failed to log out")
        }
    }

}

// MARK: - MessageCongtroller Delegate
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

// MARK: - Setup chatviewcontroller views
extension ChatViewController {
    
    func prepareViews(){
    
    }
    
    
    fileprivate func prepareNavigationBar(){
        let buttonWidth = CGFloat(85)
        let buttonHeight = CGFloat(35)
        
        let button = UIButton(type: .custom)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
}

