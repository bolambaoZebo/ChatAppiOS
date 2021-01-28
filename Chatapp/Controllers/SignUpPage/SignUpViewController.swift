//
//  SignUpViewController.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/25.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTestField: UITextField!
    @IBOutlet weak var termsAndConditionLabel: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    var refrenceForTermsAndCondition : TermsAndCondition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViews()
        self.setupLabelTap()
    }
    
    
    // setup sign up button tap
    @IBAction func signupTappedButton(_ sender: UIButton) {
        print("trying to register")
        
        usernameTextField.resignFirstResponder()
        passwordTestField.resignFirstResponder()
               
        //validate user input for registration
        guard let email = usernameTextField.text,
              let password = passwordTestField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count > 7, password.count < 17,
              email.count > 7, email.count < 17 else {
              print("Invalid email password")
                   return
        }
        
        let username = email.split(separator: "@")
        
        DatabaseManager.shared.userExists(with: email) { exits in
            guard exits else {
                print("user already exists!")
                return
            }
            //register new user to firebase
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let this = self else {
                    return
                }
                guard let  result = authResult, error == nil else {
                    print("Error creating user\(error)")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(email: email, username: String(username[0])))
                
                //after successful registration transition to login controller
                guard let parentviewcontroller = this.presentingViewController,
                      let storyboard = this.storyboard else {
                    return
                }
                this.dismiss(animated: true) {
                    ViewControllerManager.gotToViewController(from: parentviewcontroller, to: Controller.ChatRoom, storyboard: storyboard)
                }
            }
        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("when the login label is tapped")
        
        guard let parentviewcontroller = presentingViewController,
              let storyboard = self.storyboard else {
            return
        }
        dismiss(animated: true) {
            ViewControllerManager.gotToViewController(from: parentviewcontroller, to: Controller.Login, storyboard: storyboard)
        }
    }
        
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.loginLabel.isUserInteractionEnabled = true
        self.loginLabel.addGestureRecognizer(labelTap)
        
    }
        
    
}

extension SignUpViewController {
    
    // preparation for all the view to load up
    fileprivate func prepareViews(){
        
        //setup terms and condition view
        if let refrenceForTermsAndCondition = Bundle.main.loadNibNamed("TermsAndCondition", owner: self, options: nil)?.first as? TermsAndCondition {
            termsAndConditionLabel.addSubview(refrenceForTermsAndCondition)
        }
        //setup button field
        signupButton.layer.cornerRadius = 5
        passwordTestField.isSecureTextEntry = true
    }
    
}
