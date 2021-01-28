//
//  ChatViewController.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/27.
//

import UIKit
import MessageKit
import FirebaseAuth
import InputBarAccessoryView

struct Message: MessageType {
   public var messageId: String
   public var sentDate: Date
   public var kind: MessageKind
   public var sender: SenderType
}

struct Sender: SenderType {
   public var photoURL: String
   public var senderId: String
   public var displayName: String
}

class ChatViewController: MessagesViewController {
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    private var messages = [Message]()
    
    private var selfSender: Sender? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
       return Sender(photoURL: "",
               senderId: "mark@gmail.com",
               displayName: "Joe Biden")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        prepareViews()
        prepareNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    
    //log out user from the chat room
    @objc func logoutButtonTapped() {
        guard let storyboard = self.storyboard else {
            return
        }
        do {
            try FirebaseAuth.Auth.auth().signOut()
            ViewControllerManager.gotToViewController(from: self, to: Controller.PoptoRoot, storyboard: storyboard)
            print("Log out user")
        }catch {
            print("Failed to log out")
        }
    }

}

// MARK: - send button delegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender else {
            print("#####\(UserDefaults.standard.value(forKey: "email"))")
            print("selfSender Failded\(self.selfSender)")
                return
        }
        
        print("joe message \(text)")
        
        //send message to database
        let message = Message(messageId: createMeassageId(), sentDate: Date(), kind: .text(text), sender: selfSender)
        
        DatabaseManager.shared.createConversation(with: "joe@gmail.com", message: message) { success in
            
            print(success)
            if success {
                print("message sent")
            }else{
                print("failed to send")
            }
        }
        
        messageInputBar.inputTextView.text = ""
        
    }
    
    private func createMeassageId() -> String {
        let dateString = Self.dateFormatter.string(from: Date())
        let randInt = Int.random(in: 1000..<100000000)
        return "id\(dateString)_\(randInt)"
    }
}

// MARK: - MessageCongtroller Delegate
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self sender is nil*************________")
        return Sender(photoURL: "", senderId: "1234", displayName: "joe")
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

