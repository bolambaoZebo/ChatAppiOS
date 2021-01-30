//
//  LogInViewController.swift
//  Chatapp
//
//  Created by zebedee on 2021/01/25.
//

import UIKit
import FirebaseAuth

struct Helpers {
    
    static func cearteDefautUsername(_ result: String?) {
        let username = result?.split(separator: "@")
        print("User name: \(String(username!.first ?? "")) with email: \(result) is log in.")
        UserDefaults.standard.set(result, forKey: "email")
        UserDefaults.standard.set(String(username!.first ?? ""), forKey: "username")
    }
    
    static func logoutUserDefaultName() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        print("\(UserDefaults.standard.value(forKey: "username") ?? "User is logout")")
    }
    
    static func createEmailForUser(username: String) -> String {
        let newUsername = username.split(separator: "@")
        print("\(String(newUsername.first!))")
        return "\(String(newUsername.first!))@gmail.com"
    }
}
