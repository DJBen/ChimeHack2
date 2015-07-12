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
    
    func getUser(identifier: Int = 0, userID: String = "me", completion: (id: String, name: String, pictureURL: NSURL, identifier: Int) -> Void) {
        FBSDKGraphRequest(graphPath: "/\(userID)?fields=id,name,picture", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
                println(error)
                return
            }
            if let dict = result as? [String: AnyObject] {
                let userID = dict["id"]! as? String
                let name = dict["name"]! as! String
                let id = dict["id"]! as! String
                let pictureData = dict["picture"] as! [String: AnyObject]
                let pictureURL = pictureData["data"]!["url"] as! String
                let url =  NSURL(string: pictureURL)!
                completion(id: id, name: name, pictureURL: url, identifier: identifier)
            }
        })
    }
    
    func getEvents(completion: ([Event], NSError?) -> Void) {
        FBSDKGraphRequest(graphPath: "/me/events?fields=cover,id,name,rsvp_status,start_time,end_time,place,description", parameters: nil).startWithCompletionHandler { (_, result, error) -> Void in
            if error != nil {
                println(error)
                completion([], error)
                return
            }
            let events = [self.mockupEvent] + Event.eventsFromGraphAPIPayload(result as! [String: AnyObject])
            completion(events, nil)
        }
    }

    var mockupEvent: Event {
        get {
            let cover = Event.Cover(id: "chimehack2cover", sourceURL: NSURL(string: "http://www.rantlifestyle.com/wp-content/uploads/2014/08/017.jpg")!)
            let event = Event(id: "chimehack2", name: "Fraternity Annual \"Just Drink\" Party", eventDescription: "It's time to drink; it's time for fun; it's the day in the year!", startTime: NSDate(), endTime: NSDate(timeIntervalSinceNow: 60 * 60 * 2), RSVP: .Attending, place: Place(), cover: cover)
            return event
        }
    }

}
