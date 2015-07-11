//
//  ViewController.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Cartography

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    lazy var loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.delegate = self
        button.readPermissions = ["public_profile", "email", "user_friends"]
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupViews() {
        view.addSubview(loginButton)
        layout(loginButton) { b in
            b.centerX == b.superview!.centerX
            b.height == 40
            b.width == 160
            b.bottom == b.superview!.bottom - 80
        }
    }
    
    // MARK: Login button
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }

}

