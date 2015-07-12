//
//  PushNotificationManager.swift
//  ChimeHack2
//
//  Created by Joy Gao on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit

let safeIdentifier = "SAFE_IDENTIFIER"
let helpIdentifier = "HELP_IDENTIFIER"

class PushNotificationManager: NSObject {
    
    static let sharedManager = PushNotificationManager()
    
    override init() {
        super.init()
    }

    private class func createPushNotificationCategory(application: UIApplication) -> UIMutableUserNotificationCategory {
        
        let safe: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        safe.identifier = safeIdentifier
        safe.title = "I'm Cool!"
        safe.destructive = false
        safe.authenticationRequired = false
        safe.activationMode = UIUserNotificationActivationMode.Background
        
        let help: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        help.identifier = helpIdentifier
        help.title = "I Need Help! NOW!"
        help.destructive = true
        help.authenticationRequired = false
        help.activationMode = UIUserNotificationActivationMode.Foreground
        
        let category: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        category.identifier = "CheckStatus"
        category.setActions([help, safe], forContext: UIUserNotificationActionContext.Minimal)
        category.setActions([help, safe], forContext: UIUserNotificationActionContext.Default)
        
        return category
    }
    
    class func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()
        let categoryRegistration = createPushNotificationCategory(application)
        var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories:[categoryRegistration])
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
    }
    
    func handleActionWithIdentifier(application: UIApplication, handleActionWithIdentifier identifier: String?, userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if identifier == safeIdentifier {
            println("Clicked on a safe push notif")
        } else if identifier == helpIdentifier {
            println("Clicked on help push notif")
        }
        completionHandler()
    }
    
    func schedulePushNotificationWithEvent(event: Event, interval: NSTimeInterval, times: Int) {
        for i in 0..<times {
            var calendar: NSCalendar = NSCalendar.autoupdatingCurrentCalendar()
            var itemDate: NSDate = event.startTime.dateByAddingTimeInterval(interval * NSTimeInterval(i + 1))
            var localNotif: UILocalNotification = UILocalNotification()
            localNotif.fireDate = itemDate
            localNotif.timeZone = NSTimeZone.defaultTimeZone()
            localNotif.alertBody = "Are you safe in \(event.name)?"
            localNotif.alertAction = nil
            localNotif.alertTitle = "\(event.name)"
            localNotif.soundName = UILocalNotificationDefaultSoundName
            localNotif.applicationIconBadgeNumber = 1
            localNotif.category = "CheckStatus"
            localNotif.userInfo = ["event": event.id]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
        }
    }
    
    func cancelNotificationsForEvent(event: Event) {
        UIApplication.sharedApplication().scheduledLocalNotifications.map { object -> Void in
            let notification = object as! UILocalNotification
            let userInfo = notification.userInfo as! [String: AnyObject]
            let id = userInfo["event"] as! String
            if id == event.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
}

extension Event {
    func scheduleNotificationsWithInterval(interval: NSTimeInterval, times: Int) {
        PushNotificationManager.sharedManager.schedulePushNotificationWithEvent(self, interval: interval, times: times)
    }
    
    func cancelNotifications() {
        PushNotificationManager.sharedManager.cancelNotificationsForEvent(self)
    }
}

