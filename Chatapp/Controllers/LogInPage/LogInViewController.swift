//
//  LogInViewController.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/25.
//

import UIKit
import FirebaseAuth
//import FBSDKLoginKit
//import GoogleSignIn
import JGProgressHUD

class LogInViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var viewTermsAndCondition: UIView!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var refrenceForTermsAndCondition : TermsAndCondition?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViews()
        self.setupLabelTap()
    }
    
    
    // When the user click the sigup label
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        
        guard let parentviewcontroller = presentingViewController,
              let storyboard = self.storyboard else {return}
        
        dismiss(animated: true) {
            ViewControllerManager.gotToViewController(from: parentviewcontroller, to: Controller.Register, storyboard: storyboard)
        }
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.signupLabel.isUserInteractionEnabled = true
        self.signupLabel.addGestureRecognizer(labelTap)
    }
    
   // setup login up button tap
    @IBAction func logInTappedButton(_ sender: Any) {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
               
        //validate user input
        guard let userName = usernameTextField.text,
              let password = passwordTextField.text,
              !userName.isEmpty,
              !userName.isEmpty,
              password.count >= 8, password.count <= 16,
              userName.count >= 8, userName.count <= 16 else {
              print("Invalid email password")
            usernameTextField.isErrorRevealed = true
            passwordTextField.isErrorRevealed = true
                   return
        }
        
        spinner.show(in: view)
                  
        //login new user to firebase
        FirebaseAuth.Auth.auth().signIn(withEmail: userName, password: password) { [weak self] authResult, error in
            guard let this = self else {
                return
            }
            
            DispatchQueue.main.async {
                this.spinner.dismiss()
                if error != nil {
                    this.usernameTextField.isErrorRevealed = true
                    this.passwordTextField.isErrorRevealed = true
                }else{
                    this.usernameTextField.isErrorRevealed = false
                    this.passwordTextField.isErrorRevealed = false
                }
            }
            
            guard let  result = authResult, error == nil else {
                print("Failed to login user with email\(error)")
                return
            }
            
            let user = result.user.value(forKey: "email") as? String
            Helpers.cearteDefautUsername(user)
            
            //after successfull login transition to ChatRoomViewController
            guard let parentviewcontroller = this.presentingViewController,
                  let storyboard = this.storyboard else {
                return
            }
            this.dismiss(animated: true) {
                ViewControllerManager.gotToViewController(from: parentviewcontroller,
                                                          to: Controller.ChatRoom,
                                                          storyboard: storyboard)
            }
           
        }
    }
}
// MARK: - Setup for views
extension LogInViewController {
    
    fileprivate func prepareViews(){
        
        //setup terms and condition xib
        if let refrenceForTermsAndCondition = Bundle.main.loadNibNamed("TermsAndCondition", owner: self, options: nil)?.first as? TermsAndCondition {
            viewTermsAndCondition.addSubview(refrenceForTermsAndCondition)
        }
        //setup button field
        loginButton.layer.cornerRadius = 5
        passwordTextField.isSecureTextEntry = true
        passwordTextField.applyStyle(error: "value is incorrect")
        usernameTextField.applyStyle(error: "value is incorrect")
    }
}

