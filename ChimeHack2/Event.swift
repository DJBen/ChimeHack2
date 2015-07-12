//
//  Event.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class Event: NSObject, Printable {
    enum RSVPStatus: String {
        case Attending = "attending"
        case Unsure = "unsure"
    }
    
    struct Cover {
        let offset: CGPoint
        let sourceURL: NSURL
        let id: String
        
        init?(dictionary: [String: AnyObject]) {
            if let x = dictionary["offset_x"] as? Int, y = dictionary["offset_y"] as? Int, sourceString = dictionary["source"] as? String, id = dictionary["id"] as? String {
                self.offset = CGPoint(x: x, y: y)
                self.id = id
                if let url = NSURL(string: sourceString) {
                    self.sourceURL = url
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        init(offset: CGPoint = CGPointZero, id: String, sourceURL: NSURL) {
            self.offset = offset
            self.id = id
            self.sourceURL = sourceURL
        }
    }
    
    let eventDescription: String
    let id: String
    let name: String
    let RSVP: RSVPStatus
    let startTime: NSDate
    let endTime: NSDate
    let place: Place
    let cover: Cover?
    
    override var description: String {
        return "\(name) (\(startTime) - \(endTime)): \(RSVP.rawValue)"
    }
    
    // RFC 3339 date-time
    private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    init(id: String, name: String, eventDescription: String, startTime: NSDate, endTime: NSDate, RSVP: RSVPStatus, place: Place, cover: Cover? = nil) {
        self.id = id
        self.name = name
        self.eventDescription = eventDescription
        self.startTime = startTime
        self.endTime = endTime
        self.place = place
        self.cover = cover
        self.RSVP = RSVP
        super.init()
    }
    
    init?(dictionary: [String: AnyObject]) {
        let data = dictionary
        if let eventDescription = data["description"] as? String, id = data["id"] as? String, name = data["name"] as? String, startTimeString = data["start_time"] as? String, endTimeString = data["end_time"] as? String, rsvpString = data["rsvp_status"] as? String, placeDict = data["place"] as? [String: AnyObject], coverDict = data["cover"] as? [String: AnyObject] {
            self.eventDescription = eventDescription
            self.id = id
            self.name = name
            self.RSVP = RSVPStatus(rawValue: rsvpString)!
            self.place = Place(dictionary: placeDict)!
            self.cover = Cover(dictionary: coverDict)
            
            if let startTime = dateFormatter.dateFromString(startTimeString), endTime = dateFormatter.dateFromString(endTimeString) {
                self.startTime = startTime
                self.endTime = endTime
                super.init()
            } else {
                self.startTime = NSDate()
                self.endTime = NSDate()
                super.init()
                return nil
            }

        } else {
            self.eventDescription = ""
            self.id = ""
            self.name = ""
            self.RSVP = .Unsure
            self.startTime = NSDate()
            self.endTime = NSDate()
            self.place = Place()
            self.cover = nil
            super.init()
            return nil
        }
    }
    
    func writeSafeUpdate() {
        let myRootRef = Firebase(url:"https://cradle.firebaseIO.com")
        let path = myRootRef.childByAppendingPath(PFUser.currentUser()!.username!).childByAppendingPath(id)
        path.setValue(dateFormatter.stringFromDate(NSDate()), withCompletionBlock: { (error, base) -> Void in
            if error != nil {
                println(error)
            }
        })
    }
    
    class func eventsFromGraphAPIPayload(payload: [String: AnyObject]) -> [Event] {
        if let data = payload["data"] as? [[String: AnyObject]] {
            return data.flatMap { item -> [Event] in
                if let event = Event(dictionary: item) {
                    return [event]
                } else {
                    return []
                }
            }
        } else {
            return []
        }
    }
}
