//
//  PushNotificationManager.swift
//  ChimeHack2
//
//  Created by Joy Gao on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit




let safeButton = "SAFE_IDENTIFIER"
let helpButton = "HELP_IDENTIFIER"

class PushNotificationManager {
    
    init() {}

    private class func createPushNotificationCategory(application: UIApplication) -> UIMutableUserNotificationCategory {
        
        var safe: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        safe.identifier = safeButton
        safe.title = "Safe"
        safe.destructive = false
        safe.authenticationRequired = false
        safe.activationMode = UIUserNotificationActivationMode.Background
        
        var help: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        help.identifier = helpButton
        help.title = "Help"
        help.destructive = true
        help.authenticationRequired = false
        help.activationMode = UIUserNotificationActivationMode.Foreground
        
        var category: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        category.identifier = "CheckStatus"
        category.setActions([safe, help], forContext: UIUserNotificationActionContext.Minimal)
        category.setActions([safe, help], forContext: UIUserNotificationActionContext.Default)
        
        return category
    }
    
    class func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()
        let categoryRegistration = createPushNotificationCategory(application)
        var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories:[categoryRegistration])
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
    }
    
    func handleActionWithIdentifier(application: UIApplication, handleActionWithIdentifier identifier: String?, userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if identifier == safeButton {
            println("Clicked on a safe push notif")
        } else if identifier == helpButton {
            println("Clicked on help push notif")
        }
        completionHandler()
    }
}

