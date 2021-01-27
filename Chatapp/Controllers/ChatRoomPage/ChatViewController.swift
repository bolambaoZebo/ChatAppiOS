//
//  ChatViewController.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/27.
//

import UIKit
import MessageKit
import FirebaseAuth

class ChatViewController: MessagesViewController {

    let buttonWidth = CGFloat(85)
    let buttonHeight = CGFloat(35)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension ChatViewController {
    
    fileprivate func prepareViews(){
        
    }
    fileprivate func prepareNavigationBar(){
        
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

