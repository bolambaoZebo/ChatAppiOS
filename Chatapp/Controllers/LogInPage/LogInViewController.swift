//
//  LogInViewController.swift
//  Chatapp
//
//  Created by dnamicro on 2021/01/25.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var viewTermsAndCondition: UIView!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var refrenceForTermsAndCondition : TermsAndCondition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat app"
        prepareViews()
    }
    
    
    fileprivate func prepareViews(){
        
        //setup terms and condition xib
        if let refrenceForTermsAndCondition = Bundle.main.loadNibNamed("TermsAndCondition", owner: self, options: nil)?.first as? TermsAndCondition {
            viewTermsAndCondition.addSubview(refrenceForTermsAndCondition)
        }
        
        //setup button field
        loginButton.layer.cornerRadius = 5
    }
    
}
