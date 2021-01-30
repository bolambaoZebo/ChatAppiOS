//
//  Helper.swift
//  Chatapp
//
//  Created by dnamicro on 2021/01/30.
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
}
