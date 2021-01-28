//
//  ViewControllerManager.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/27.
//

import UIKit

enum Controller {
    case Login
    case Register
    case ChatRoom
    case PoptoRoot
}
struct ViewControllerManager {
    
    static func gotToViewController(from: UIViewController, to: Controller, storyboard: UIStoryboard) {
        switch to {
        case .Login:
            let logInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            let nav = UINavigationController(rootViewController: logInViewController)
            logInViewController.title = "Chat App"
            from.present(nav, animated: true)
        case .Register:
            let signupViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            let nav = UINavigationController(rootViewController: signupViewController)
            signupViewController.title = "Chat App"
            from.present(nav, animated: true)
        case .ChatRoom:
            let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            let nav = UINavigationController(rootViewController: chatRoomViewController)
            nav.modalPresentationStyle = .fullScreen
            chatRoomViewController.title = "Chat App"
            from.present(nav, animated: true)
        case .PoptoRoot:
            //from.navigationController?.popToRootViewController(animated: true)
            from.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
        

    }
}
