//
//  MainViewController.swift
//  Chatapp
//
//  Created by dnamicro on 2021/01/26.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareViews()
    }
    

    fileprivate func prepareViews(){
        signupButton.layer.cornerRadius = 4
        loginButton.layer.cornerRadius = 4
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        print("sign up")
        let signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let nav = UINavigationController(rootViewController: signupViewController)
        present(nav, animated: true)
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("login")
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        //(withIdentifier: "LogInViewController" as! LogInViewController
        let navigationVC = UINavigationController(rootViewController: loginViewController)
        self.present(navigationVC, animated: true, completion: nil)
    }
}
