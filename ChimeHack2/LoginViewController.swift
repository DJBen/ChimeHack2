//
//  ViewController.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import Cartography
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    static let EventsTableViewControllerSegueIdentifier = "events"
    
    lazy var loginButton: UIButton = {
        let button = UIButton.buttonWithType(.Custom) as! UIButton
        button.setImage(UIImage(named: "icon_facebook"), forState: .Normal)
        button.addTarget(self, action: "login:", forControlEvents: .TouchUpInside)
        button.tintColor = UIColor(red: 59/255.0, green: 85/255.0, blue: 152/255.0, alpha:1)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier(LoginViewController.EventsTableViewControllerSegueIdentifier, sender: self)
        }
    
        NSNotificationCenter.defaultCenter().addObserverForName(SafeNotificationName, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let eventId = notification.userInfo!["event"] as! String
            self.performSegueWithIdentifier(LoginViewController.EventsTableViewControllerSegueIdentifier, sender: eventId)
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
            b.height == 80
            b.width == b.height
            b.bottom == b.superview!.bottom - 80
        }
        
        layout(imageView) { v in
            v.edges == v.superview!.edges
        }
    }
    
    // MARK: - Login button
    
    func login(sender: UIButton) {
        let login = { [weak self] in
            self?.performSegueWithIdentifier(LoginViewController.EventsTableViewControllerSegueIdentifier, sender: self)
        }
        if PFUser.currentUser() != nil {
            login()
            return
        }
        let readPermissions = ["public_profile", "email", "user_friends", "user_events", "user_photos"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(readPermissions) { (user, error) -> Void in
            if error != nil {
                println(error)
                return
            }
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
                login()
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! EventsTableViewController
        if let id = sender as? String {
            vc.preselectedEventId = id
        }
    }

}

