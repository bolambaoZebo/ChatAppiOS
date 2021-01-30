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


class ChatViewController: MessagesViewController {
   
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,
              let username = UserDefaults.standard.value(forKey: "username") as? String else {
            return nil
        }
       return Sender(photoURL: "",
               senderId: email,
               displayName: username)
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
           DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
               switch result {
               case .success(let messages):
                   print("success in getting messages: \(messages)")
                   guard !messages.isEmpty else {
                       print("messages are empty")
                       return
                   }
                   self?.messages = messages

                   DispatchQueue.main.async {
                       self?.messagesCollectionView.reloadDataAndKeepOffset()

                       if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToLastItem()
                       }
                   }
               case .failure(let error):
                   print("failed to get messages: \(error)")
               }
           })
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

     
        let usersmessages = listenForMessages(id: "chatroom", shouldScrollToBottom: true)
    }
    
    
    //log out user from the chat room
    @objc func logoutButtonTapped() {
        guard let storyboard = self.storyboard else {
            return
        }
        do {
            try FirebaseAuth.Auth.auth().signOut()
            Helpers.logoutUserDefaultName()
            ViewControllerManager.gotToViewController(from: self, to: Controller.Register, storyboard: storyboard)
        }catch {
            print("Failed to log out")
        }
    }

}


// MARK: - send button delegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let userName = UserDefaults.standard.value(forKey: "username") as? String,
              let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return
        }
        
        print("\(email) message \(text)")
        
        //send message to database
        let message = Message(sender: selfSender, messageId: createMeassageId(), sentDate: Date(), kind: .text(text))
        
        DatabaseManager.shared.createConversation(with: "email", name: String(userName ?? "anonymous"), messageKind: message) { success in
            
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
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return "no currentEmail"
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        let dateString = Self.dateFormatter.string(from: Date())
        let randInt = Int.random(in: 1000..<100000000)
        return "id\(dateString)_\(randInt)_\(safeEmail)"
    }
}

// MARK: - MessageCongtroller Delegate
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        return Sender(photoURL: "", senderId: "", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = message.sender.displayName
            return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
    
 
}

// MARK: - Setup chatviewcontroller views
extension ChatViewController {
    
    func prepareViews(){
        
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: .zero))
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: .zero))
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
        
        messageInputBar.sendButton.backgroundColor = .darkGray
        messageInputBar.sendButton.layer.cornerRadius = 5
        
        messageInputBar.inputTextView.becomeFirstResponder()
        messageInputBar.inputTextView.placeholder = "Strat a new message"
        messageInputBar.inputTextView.layer.cornerRadius = 5
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

// MARK: - public date formatter
extension ChatViewController {
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
}

