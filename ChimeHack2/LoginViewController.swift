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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    static let EventsTableViewControllerSegueIdentifier = "events"
    
    lazy var loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.delegate = self
        button.readPermissions = ["public_profile", "email", "user_friends", "user_events", "user_photos"]
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            performSegueWithIdentifier(LoginViewController.EventsTableViewControllerSegueIdentifier, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(loginButton)
        
        layout(loginButton) { b in
            b.centerX == b.superview!.centerX
            b.height == 45
            b.width == 200
            b.bottom == b.superview!.bottom - 80
        }
        
        layout(imageView) { v in
            v.edges == v.superview!.edges
        }
    }
    
    // MARK: - Login button
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            println(error)
            return
        }
        performSegueWithIdentifier(LoginViewController.EventsTableViewControllerSegueIdentifier, sender: self)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }

}

