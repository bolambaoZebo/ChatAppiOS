//
//  MainViewController.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/26.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    //Validate user isloggedIn
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            print("is logged in")
            guard let storyboard = self.storyboard else {
                return
            }
            ViewControllerManager.gotToViewController(from: self, to: Controller.ChatViewController, storyboard: storyboard)
            
        }
    }
 
}

// MARK: - Setup button transition to sigup or login
extension MainViewController {
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        print("sign up")
        guard let storyboard = self.storyboard else {
            return
        }
        ViewControllerManager.gotToViewController(from: self, to: Controller.Register, storyboard: storyboard)
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("login")
        guard let storyboard = self.storyboard else {
            return
        }
        ViewControllerManager.gotToViewController(from: self, to: Controller.Login, storyboard: storyboard)
    }
    
}
// MARK: - Setup view customization
extension MainViewController {
    
    fileprivate func prepareViews(){
        signupButton.layer.cornerRadius = 4
        loginButton.layer.cornerRadius = 4
    }
    
}
