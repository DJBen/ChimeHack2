//
//  ChimeHackManager.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import FBSDKCoreKit

let ChimeHackErrorDomain = "ChimeHackErrorDomain"
let CHM = ChimeHackManager.sharedManager

class ChimeHackManager: NSObject {
    static let sharedManager = ChimeHackManager()
    
    override init() {
        super.init()
    }
    
    private var userID: String?
    
    func getUserID(completion: (String) -> Void) {
        if userID == nil {
            FBSDKGraphRequest(graphPath: "/me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error != nil {
                    println(error)
                    return
                }
                if let dict = result as? [String: String] {
                    self.userID = dict["id"]!
                    completion(self.userID!)
                }
            })
        } else {
            completion(userID!)
        }
    }
    
    func getEvents(completion: ([Event], NSError?) -> Void) {
        FBSDKGraphRequest(graphPath: "/me/events?fields=cover,id,name,rsvp_status,start_time,end_time,place,description", parameters: nil).startWithCompletionHandler { (_, result, error) -> Void in
            if error != nil {
                println(error)
                completion([], error)
                return
            }
            let events = Event.eventsFromGraphAPIPayload(result as! [String: AnyObject])
            completion(events, nil)
        }
    }
}
