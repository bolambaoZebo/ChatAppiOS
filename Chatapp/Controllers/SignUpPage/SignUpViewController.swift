//
//  SignUpViewController.swift
//  Chatapp
//
//  Created by dnamicro on 2021/01/25.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTestField: UITextField!
    @IBOutlet weak var termsAndConditionLabel: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    var refrenceForTermsAndCondition : TermsAndCondition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat app"
        
        prepareViews()
    }
    
    
    fileprivate func prepareViews(){
        if let refrenceForTermsAndCondition = Bundle.main.loadNibNamed("TermsAndCondition", owner: self, options: nil)?.first as? TermsAndCondition {
            termsAndConditionLabel.addSubview(refrenceForTermsAndCondition)
        }
    }

}
